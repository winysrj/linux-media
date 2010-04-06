Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36281 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab0DFLGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 07:06:22 -0400
Subject: Re: RFC: exposing controls in sysfs
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>
In-Reply-To: <201004060837.24770.hverkuil@xs4all.nl>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <201004060012.48261.hverkuil@xs4all.nl>
	 <201004060837.24770.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 06 Apr 2010 07:06:18 -0400
Message-Id: <1270551978.3025.38.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:
> On Tuesday 06 April 2010 00:12:48 Hans Verkuil wrote:
> > On Monday 05 April 2010 23:47:10 Hans Verkuil wrote:

 
> > One thing that might be useful is to prefix the name with the control class
> > name. E.g. hue becomes user_hue and audio_crc becomes mpeg_audio_crc. It would
> > groups them better. Or one could make a controls/user and controls/mpeg
> > directory. That might not be such a bad idea actually.
> 
> Replying to your own mails is probably a bad sign, but I can't help myself :-)

I had an old InfoCom text adventure game that would respond to querying
oneself with: "Talking to oneself is a sign of impending mental
collapse."

:D


> I've changed the code to add a control class prefix for all but the user controls.
> It looks much better now:
> 
> $ ls /sys/class/video4linux/video1/controls
> balance                           mpeg_insert_navigation_packets     mpeg_video_aspect
> brightness                        mpeg_median_chroma_filter_maximum  mpeg_video_b_frames
> chroma_agc                        mpeg_median_chroma_filter_minimum  mpeg_video_bitrate
> chroma_gain                       mpeg_median_filter_type            mpeg_video_bitrate_mode
> contrast                          mpeg_median_luma_filter_maximum    mpeg_video_encoding
> hue                               mpeg_median_luma_filter_minimum    mpeg_video_gop_closure
> mpeg_audio_crc                    mpeg_spatial_chroma_filter_type    mpeg_video_gop_size
> mpeg_audio_emphasis               mpeg_spatial_filter                mpeg_video_mute
> mpeg_audio_encoding               mpeg_spatial_filter_mode           mpeg_video_mute_yuv
> mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type      mpeg_video_peak_bitrate
> mpeg_audio_mute                   mpeg_stream_type                   mpeg_video_temporal_decimation
> mpeg_audio_sampling_frequency     mpeg_stream_vbi_format             mute
> mpeg_audio_stereo_mode            mpeg_temporal_filter               saturation
> mpeg_audio_stereo_mode_extension  mpeg_temporal_filter_mode          volume

So this is beginning to look OK.  You'll have longer names when a class
name is longer than 4 characters (e.g. "technician_" ).  However, I
suppose it is better than another directory which creates a deeper
hierarchy while still not avoiding the longer pathname.



> > > One of the few drivers that exposes controls in sysfs is pvrusb2. As far as
> > > I can tell from the source it will create subdirectories under the device
> > > node for each control. Those subdirs have the name ctl_<control-name> (e.g.
> > > ctl_volume), and below that are files exposing all the attributes of that
> > > control: name, type, min_val, max_val, def_val, cur_val, custom_val, enum_val
> > > and bit_val. Most are clear, but some are a bit more obscure. enum_val is
> > > basically a QUERYMENU and returns all menu options. bit_val seems to be used
> > > for some non-control values like the TV standard that pvrusb2 also exposes
> > > and where bit_val is a bit mask of all the valid bits that can be used.
> > > 
> > > Mike, if you have any additional information, just let us know. My pvrusb2
> > > is in another country at the moment so I can't do any testing.
> > > 
> > > Personally I think that it is overkill to basically expose the whole
> > > QUERYCTRL information to sysfs. I see it as an easy and quick way to read and
> > > modify controls via a command line.


> > An in between solution would be to add _type files. So you would have 'hue' and
> > 'hue_type'. 'cat hue_type' would give something like:
> 
> If we go for something like this, then I think it would be better to make a
> new subdirectory. So 'controls' just has the controls, and 'ctrl_info' or
> something similar would have read-only files containing this information.

sysfs' major usability problem for humans is the insane directory depths
it can reach and the cross-links to everywhere.  Humans attempt to keep
a mental model of "where" they are in a logical "space", and sysfs is
like "maze of twisty little passages, all alike".

In the true sysfs spirit you should create a 'ctrl_info' directory full
of nodes with metadata *and* also create "foo_type" symlinks to all of
those metadata nodes.  Bonus points for having the 'ctrl_info' directory
and 'foo_type' symlinks in a different part of the sysfs tree but with a
similar directory name.


> Again, I still don't know whether we should do this. It is dangerously
> seductive because it would be so trivial to implement.

It's like watching ships run aground on a shallow sandbar that all the
locals know about.  The waters off of 'Point /sys' are full of usability
shipwrecks.  I don't know if it's some siren's song, the lack of a light
house, or just strange currents that deceive even seasoned
navigators....


Let the user run 'v4l2-ctl -d /dev/videoN -L' to learn about the control
metatdata.  It's not as easy as typing 'cat', but the user base using
sysfs in an interactive shell or shell script should also know how to
use v4l2-ctl.  In embedded systems, the final system deployment should
not need the control metadata available from sysfs in a command shell
anyway.


Regards,
Andy

