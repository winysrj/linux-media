Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab0EZPhF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 11:37:05 -0400
Message-ID: <4BFD4079.3040905@redhat.com>
Date: Wed, 26 May 2010 17:38:33 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: a processing plugin API for libv4l
Content-Type: multipart/mixed;
 boundary="------------030008020605060001020000"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030008020605060001020000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

See attachment.

Regards,

Hans

--------------030008020605060001020000
Content-Type: text/plain;
 name="libv4l-processing-plugin-rfc.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libv4l-processing-plugin-rfc.txt"

RFC: a processing plugin API for libv4l
=======================================

Since libv4l-0.6.x libv4l has the ability to do various video
processing steps in software:
- white balance
- gamma correction
- autogain and exposure (simply called autogain inside libv4l)
- H- and V-flipping

During the Plumbers conference in 2009 various parties expresse interest
in extending libv4l's processing capabilities. Some hardware can do some
processing steps in hardware, but this needs to be setup from userspace
and sometimes still need some regulation from userspace as streaming
happens, hardware specific libv4l plugins could be a solution here.

Fundementally most processing consists of 2 steps:
1) Measuring
2) Correcting

IE, libv4l's current whitebalance algorithm, calculates the average
r, g and b values for the image every few frames and calculates
correction factors for all r, g and b pixel values to make the averages
equal (measure), and then applies these correction factors to every
frame when the frame is dequeued (correction). Some processing consists
only of the correction step such as flipping.

Both of these steps can be done either in software or in hardware. When
either of these steps is done in software, the frames need to be in a
format the processing code understands.

So a processing plugin API will need to provide a way for the plugin
to communicate which of the steps it needs / wants to do. And when it
does software processing which formats it accepts for each of the steps.

In some cases plugings will need to be notified of setfmt calls so that
they can program statistics gathering hardware to match the selected
mode.


API proposal
------------

/* Plugin flags */

/* This processing step is done in software, the presence of this flag
   for a step forces libv4lconvert to convert the frame data to RGB24,
   BGR24 or raw bayer before calling the processing functions. */
#define LIBV4LPROCESSING_SOFTWARE 0x01
/* This software processing step also accepts YUV420 and YVU420
   formats, (this avoids the need for a possible double conversion when
   the apps wants YUV data). */
#define LIBV4LPROCESSING_SOFTWARE_YUV 0x02
/* Normally the processing code will only call a plugins measure function
   every few (5 by default) frames to save cpu. This flag indicates the
   measure function should be called on every dequeued frame. Note that
   plugins using this flag may not use the lookup table mechanism for
   correction ! */
#define LIBV4LPROCESSING_NO_LAZY_MEASURE 0x04

/* Plugin measure and correction function return values (these can be
   or-ed together when needed). */

/* The measure function has modified the lookup tables, so the processing
   core should apply these to dequeued frames during the correction fase. */
#define LIBV4LPROCESSING_MODIFIED_LOOKUP_TABLE 0x01
/* The function has modified hardware settings so lazy measure. Returning
   this results in lazy measuring temporarily being disabled so that measure
   functions can adjust the correction of their plugin for the new settings.

   Note that adjustment of hardware settings may be done directly from the
   measure function, so this can be returned by either the measure or the
   correction function. */
#define LIBV4LPROCESSING_HW_SETTINGS_CHANGED 0x02


struct libv4lprocessing_plugin {
  int flags;

  /* Intialize the plugin, fd is the fd of the video device, control is
     a (the) libv4lcontrol instance which can be used to add fake
     controls to for controlling the plugin.
     The returned void * can be used for plugin private data and will be
     passed in to all other functions. Return NULL to tell the processing
     core that this plugin could not load (for example because it is
     for specific hardware which is not present). */
  void *(*init)(int fd, struct libv4lcontrol_data *control);

  /* Cleanup function called upon unloading of the plugin. */
  void (*cleanup)(void *plugin_data);

  /* This function returns if this plugin is active at this time, returning
     0 results in the measure and correction functions not getting called
     (for the frame being processed). */
  int (*active)(void *plugin_data);

  /* Measure function (may be NULL when no measuring is done). 
     * When LIBV4LPROCESSING_SOFTWARE is set in flags this function 
       function gets passed in (treat as read only) the data of a just
       dequeued frame in a suitable format.
     * When LIBV4LPROCESSING_SOFTWARE is set in measure_flags and
       LIBV4LPROCESSING_SOFTWARE_YUV is not set, this function gets
       passed in 3 (rgb) lookuptable pointers. This function may modify
       the lookup tables (taking into account the value put in there by
       other plugins' measure functions), so that they result in the
       desired correction. This way libv4lprocessing can do the
       correction for multiple plugins in one pass, significantly
       reducing cpu cost. */
  int (*measure)(void *plugin_data, const unsigned char *buf,
                 const struct v4l2_format *fmt, unsigned char *lookup[3]);

  /* Correction function (may be NULL)
     * When LIBV4LPROCESSING_SOFTWARE is set in flags this function 
       function gets passed in (treat as read only) the data of a just
       dequeued frame in a suitable format. */
  int (*correct)(void *plugin_data, unsigned char *buf,
                 const struct v4l2_format *fmt);

  /* Called when a s_fmt call is made *to the hardware*, iow this functions
     argument represents the format as seen by the hardware, not necessarily
     as seen by the application (as libv4l may be doing format conversion) */
};


Controlling processing plugins through "fake" controls
------------------------------------------------------

Since libv4l-0.6.x libv4l, libv4l has the concept of fake controls, this
are controls at the libv4l level, libv4l intercepts ctrl related ioctls
and will emulate them when they apply to controls which it is using to
control its processing code, this is handled inside the libv4lcontrol
part of libv4l.

These fake controls use a shared memory (1 page) to store the control
values, this way changes made in 1 app (ie a control panel app) can be
made to happen in another app (ie an app streaming video). Each faked
control uses a 32 bit integer with a fixed index into the page. The
index has to be fixed so that all apps interpret the shared memory
the same indepenent of for example then order in which processing
plugins get loaded.

With the new plugin API deciding which controls to fake gets moved to
the plugins. Plugins can ask libv4lcontrol to fake a specific control,
after which libv4l will intercept calls to it.

The following libv4lcontrol functions (some of which are new) are
relevant for processing plugins. Note the enum with the fixed indexes, this
means that if a plugin wants to use a control which was not yet assigned an
idx, an libv4lcontrol change (extension) will be necessary. This is
deliberate, because of the need of fixed indexes into the shared memory.

enum v4lcontrol_idx {
	V4LCONTROL_WHITEBALANCE,
	V4LCONTROL_HFLIP,
	V4LCONTROL_VFLIP,
	V4LCONTROL_GAMMA,
	V4LCONTROL_AUTOGAIN,
	V4LCONTROL_AUTOGAIN_TARGET,
	V4LCONTROL_COUNT
};

/* Tell libv4lcontrol to intercept ctrl ioctl's for the control referred
   to by idx. type, min, max, step and default are used in the faked query
   ctrl answer. If the shared memory for storing control data did not exist
   when the v4lcontrol instance was created, the value of the control gets
   set to default.
   For menu type controls menu_entries should point to max strings for
   VIDIOC_QUERYMENU answers.
   The CID and name are determined by libv4lcontrol itself based on the idx.
   Note that libv4lcontrol *refuses* to fake controls which are also present
   in hardware, when this or an other error happens, this functions returns
   -1 and sets errno. On success 0 is returned. */
int v4lcontrol_add_control(struct v4lcontrol_data *control_data,
                           enum v4lcontrol_idx idx,
			   enum v4l2_ctrl_type type,
			   int min, int max, int step, int default,
                           const char *menu_entries[]);

/* This function returns the current value of the control, this can be used
   by processing plugins active, measure and correct callbacks. */
int v4lcontrol_get_ctrl(struct v4lcontrol_data *control_data,
			enum v4lcontrol_idx idx);

/* Check if the controls have changed since the last time this function
   was called. This function is used by the processing core, to force
   calling all plugins measure methods on a control change (iow to
   temporarily disable lazy measuring). */
int v4lcontrol_controls_changed(struct v4lcontrol_data *control_data); 


Processing plugins which need to handle asynchroneous events
------------------------------------------------------------

libv4l's processing code is all driven by the application, so plugins
methods get called on dqbuf. Some plugins however may want to respond
to hardware generated "measuring" information sooner, for example when
the hardware gathers information about the center part of the frames,
as soon as the last line of that center part is scanned out the hardware
(and driver) could generate an event and a processing plugin may want
to pick this up and act on it to get new settings in place before
the next frame starts (when waiting till dqbuf, these settings would
come into effect one frame later assuming they are synced to vsync).

Plugins can do this by using a thread to listen to these events, and
make the necessary hardware settings from this thread. Plugins should
use regular pthreads for this, and plugins are responsible to do their
own synchronisation between callbacks from the main thread (such as a 
s_fmt notification) and their event listening thread.

Also plugins should report a LIBV4LPROCESSING_HW_SETTINGS_CHANGED return
status from their measure callback, on the first call to their measure
callback after making changes to hardware settings which may effect the
measuring done by other plugins (there is no need to do this when the
changed settings do not potentially change things like colorbalance
and brightness level of the picture).

--------------030008020605060001020000--
