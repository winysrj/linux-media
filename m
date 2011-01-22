Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1387 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1AVRMe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 12:12:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC PATCH 1/3] v4l2-ctrls: must be able to enable/disable controls
Date: Sat, 22 Jan 2011 18:12:25 +0100
Cc: linux-media@vger.kernel.org
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl> <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl> <1295712672.2427.20.camel@localhost>
In-Reply-To: <1295712672.2427.20.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101221812.25564.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 22, 2011 17:11:12 Andy Walls wrote:
> On Sat, 2011-01-22 at 12:05 +0100, Hans Verkuil wrote: 
> > Controls can be dependent on the chosen input/output. So it has to be possible
> > to enable or disable groups of controls, preventing them from being seen in
> > the application.
> 
> I'm not a human factors expert, but given some of the principles listed
> here:
> 
> 	http://www.asktog.com/basics/firstPrinciples.html
> 
> I get the feeling that forcing controls to disappear and reappear will
> not be good for every possible application UI design.

They already have to do that anyway since changing input might also mean
changing input standard, formats, etc.

I doubt many do that, though, since having different inputs with different
standard/formats/controls etc. is pretty rare. Although with embedded systems
this will become more common.
 
> I'm sure that due to subdevices providing all sorts of interesting
> controls, some method of disabling controls is needed so as not to show
> duplicates, etc.
> 
> However, would it be better to provide a hint to the application and let
> the application UI designer decide what gets shown; instead of the
> kernel dictating what is shown?  

An alternative might be to enumerate all controls but set the DISABLED flag
for disabled controls. But this is just half the story. For controls that are
common to multiple inputs you still need to update them since the min/max ranges
may have changed after you changed inputs.

That said, it may not be a bad idea to use the DISABLED flag. It does allow a UI
application to populate the control panel with all possible controls. However,
it would require a small change to the spec since right now it says this:

Table A.80. Control Flags

V4L2_CTRL_FLAG_DISABLED	0x0001	This control is permanently disabled and should
be ignored by the application. Any attempt to change the control will result in an
EINVAL error code.

That does not quite fit what the new situation will be.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
