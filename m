Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42516 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0EUIyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 04:54:19 -0400
Received: by wyg36 with SMTP id 36so493001wyg.19
        for <linux-media@vger.kernel.org>; Fri, 21 May 2010 01:54:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <OF6F083EE0.F533D772-ON4825772A.000BE639-4825772A.000C0D74@logitech.com>
References: <AANLkTikMhseqvpIJHnmEUhouqvdYRaaUvE4jUFiAwgrH@mail.gmail.com>
	 <OF6F083EE0.F533D772-ON4825772A.000BE639-4825772A.000C0D74@logitech.com>
Date: Fri, 21 May 2010 09:54:17 +0100
Message-ID: <AANLkTimk-n69H8pRbdzOzAHsjwOn8VgCIU9HE5Lpahnc@mail.gmail.com>
Subject: Re: [RFC] V4L2 Controls State Store/Restore File Format
From: Paulo Assis <pj.assis@gmail.com>
To: Martin_Rubli@logitech.com
Cc: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Hi,

2010/5/21  <Martin_Rubli@logitech.com>:
> Hi Paulo,
>
> I haven't looked into the details, but why not use an XML format? It's less
> concise, yes, but it's standard, more extensible, and you don't have to
> worry about parsing it too much - after all, we already use libxml in
> libwebcam.
>

I've thought about this initially, xml would provide a standard format
without the strict rules of the one I'm proposing and yes it would be
very extensible and would also make it very simple to group controls,
however it as some drawbacks.
Mainly it is very hard to parse with standard c code and it would
almost certainly require an external lib (libxml).
This would be ok for libwebcam and probably some other apps, but the
idea was to create a format that requires only very simple code to
use.
When we finally decide on a format I'll right a small example that can
easily be integrated into any application, so I would rather not use
any external libs.
IMHO xml would be an overkill in this case, but if the general opinion
is that such format should be used instead I can easily change the
proposal to a xml format.

Regards,
Paulo


> Cheers,
> Martin
>
>
> Paulo Assis <pj.assis@gmail.com> wrote on 2010-05-20 21:11:36:
>
>> From: Paulo Assis <pj.assis@gmail.com>
>> To: Hans de Goede <hdegoede@redhat.com>
>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
>> Martin_Rubli@logitech.com
>> Date: 2010-05-20 21:11
>> Subject: [RFC] V4L2 Controls State Store/Restore File Format
>>
>> Hans,
>> Below is the RFC with my proposed control state file format for
>> store/restore functionality.
>> I have several doubts, mostly regarding controls that must be set
>> atomically with the extended control API.
>> The main question is:
>> How does an application know that a group of controls must be set
>> atomically ?
>> Is this reported by the driver or is it something that the application
>> must know.
>>
>> Also for string controls, I've only seen two implementations on RDS
>> controls, so I've set these with low precedence/priority order
>> compared with other control types.
>>
>> Awaiting comments, bash it all you want :-)
>>
>> Regards,
>> Paulo
>> ______________________
>>
>> [RFC] V4L2 Controls State Store/Restore File Format
>>
>> VERSION
>>
>> 0.0.1
>>
>> ABSTRACT
>>
>> This document proposes a standard for the file format used by v4l2
>> applications to store/restore the controls state.
>> This unified file format allows sharing control profiles between
>> applications, making it much easier on both developers and users.
>>
>> INTRODUCTION
>>
>> V4l2 controls can be divided by classes and types.
>> Controls in different classes are not dependent between themselves, on
>> the other end if two controls belong to the same class they may or may
>> not be dependent.
>> A good example are automatic controls and their absolute counterparts,
>> e.g.: V4L2_CID_AUTOGAIN and V4L2_CID_GAIN.
>> Controls must be set following the dependency order, automatic
>> controls must be set first or else setting the absolute value may
>> fail, when that was not the intended behavior (auto disabled).
>> After a quick analyses of the v4l2 controls, we are left to conclude
>> that auto controls are in most cases of the
>> boolean type, with some exceptions like V4L2_CID_EXPOSURE_AUTO, that
>> is of the menu type.
>> So ordering control priority by control type seems logical and it can
>> be done in the following order:
>>
>> 1-V4L2_CTRL_TYPE_BOOLEAN
>> 2-V4L2_CTRL_TYPE_MENU
>> 3-V4L2_CTRL_TYPE_INTEGER
>> 4-V4L2_CTRL_TYPE_INTEGER64
>> 5-V4L2_CTRL_TYPE_STRING
>>
>> Button controls are stateless so they can't be stored and thus are out
>> of the scope of this document.
>> Relative controls are also in effect stateless, since they will always
>> depend on their current state and thus can't be stored.
>>
>> There are also groups of controls that must be set atomically, so
>> these need to be grouped together and properly identified when loading
>> the controls state from a file.
>>
>> The proposed file format takes all of this into account and tries to
>> make implementation of both store and restore functionality as easy as
>> possible.
>>
>> FILE FORMAT
>>
>> The proposed file format is a regular text file with lines terminating
>> with the newline character '\n'.
>> Comments can be inserted by adding '#' at the beginning of the line,
>> and can safely be ignored when parsing the file.
>>
>> FILE EXTENSION
>>
>> Although not much relevant, the file extension makes it easy to
>> visually identify the file type and  also for applications to list
>> relevant files, so we propose that v4l2 control state files be
>> terminated by the suffix: ".v4l"
>>
>> FILE HEADER
>>
>> The file must always start with a commented line containing the file
>> type identification and the version of this document on which it is
>> based:
>>
>> #V4L2/CTRL/0.0.1
>>
>> Additionally it may contain extra information like the application
>> name that generated the file and for usb devices the vid and pid of
>> the device to whom the controls relate in hexadecimal notation:
>>
>> APP_NAME{"application name"}
>> VID{0x00}
>> PID{0x00}
>>
>> CONTROLS DATA
>>
>> The controls related data must be ordered by control type and for each
>> type the ordering must be done by control ID. Ordering by control ID
>> will also group the controls by class.
>> The exception to the above rule are controls that need to be set
>> atomically, these must be grouped together independent of their type.
>>
>> Each control must have is data set in a single line:
>> ID{0x0000};CHK{min:max:step:def};EXT{[0|>0}=VAL{value}
>>
>> The ID key is the control v4l2 id in hex notation.
>> The CHK key is used to match the control stored in file to the one we
>> are trying to set on the device.
>> Controls on different devices may have identical ID's but is unlikely
>> that the correspondent values remain the same. All values are in
>> decimal notation and correspond to the controls reported values.
>> EXT indicates if the control must be set atomically, if it is set to a
>> value higher than zero, then the next controls must be searched for
>> identical EXT values,  all of them shall then be grouped and set using
>> the extension control mechanism, VIDIOC_S_EXT_CTRLS.
>> Controls with a EXT value of 0 can be set individually with a regular
>> VIDIOC_S_CTRL.
>> The VAL key contains the control state in decimal form.
>
