Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2495 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1GDGms (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 02:42:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Kudos for the new vtl2 ctrls framework
Date: Mon, 4 Jul 2011 08:42:39 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E10CB5D.90802@redhat.com>
In-Reply-To: <4E10CB5D.90802@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107040842.39172.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, July 03, 2011 22:04:45 Hans de Goede wrote:
> Hi all,
> 
> After making some serious use of it in the pwc driver cleanup
> I would like to thank Hans V. for all his hard work on the
> new ctrl framework.
> 
> The clusters bit got a bit getting used to / but once I did
> it is great.
> 
> Once you get it, it really makes sense to group certain ctrls
> into clusters which then get set in a single call to the driver,
> allowing more or less atomic handling of things like autofoo +
> foo changing. And in the pwc case also grouping the pan and
> tilt controls, which get set with a single usb command,
> so that with s_ex_ctrls an app can in theory do diagonal
> moving of the camera rather then stair case moving.
> 
> Thanks Hans V.!

My pleasure!

I'll review the pwc patches this week. The pwc driver is used for some
astronomy work including things like long exposure settings. So I'll make
sure that that part is still working (or better, is working again since it
broken after the V4L1 removal).

Regards,

	Hans
