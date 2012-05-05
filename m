Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2328 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2EEOuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 10:50:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control framework.
Date: Sat, 5 May 2012 16:50:03 +0200
Cc: linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <201205051034.30484.hverkuil@xs4all.nl> <4FA53D48.6020004@redhat.com>
In-Reply-To: <4FA53D48.6020004@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051650.03626.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat May 5 2012 16:46:32 Hans de Goede wrote:
> Hi,
> 
> On 05/05/2012 10:34 AM, Hans Verkuil wrote:
> > On Sat May 5 2012 09:43:01 Hans de Goede wrote:
> >> Hi,
> >>
> >> I'm slowly working my way though this series today (both review, as well
> >> as some tweaks and testing).
> >
> > Thanks for that!
> >
> > One note: I initialized the controls in sd_init. That's wrong, it should be
> > sd_config. sd_init is also called on resume, so that would initialize the
> > controls twice.
> 
> You cannot move the initializing of the controls to sd_config, since in many
> cases the sensor probing is done in sd_init, and we need to know the sensor
> type to init the controls.

Or you move the sensor probing to sd_config as I did. It makes no sense
anyway to do sensor probing every time you resume.

Unless there is another good reason for doing the probing in sd_init I prefer
to move it to sd_config.

Regards,

	Hans

> I suggest that instead you give the sd_init
> function a resume parameter and only init the controls if the resume parameter
> is false.
> 
> > I'm working on this as well today, together with finishing the stv06xx and
> > mars conversion.
> 
> Cool!
> 
> Regards,
> 
> Hans
> 
