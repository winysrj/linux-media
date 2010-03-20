Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2823 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0CTVha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 17:37:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: e9hack <e9hack@googlemail.com>
Subject: Re: av7110 and budget_av are broken!
Date: Sat, 20 Mar 2010 22:37:23 +0100
Cc: linux-media@vger.kernel.org
References: <4B8E4A6F.2050809@googlemail.com> <201003201520.40069.hverkuil@xs4all.nl> <4BA4F1B5.80500@googlemail.com>
In-Reply-To: <4BA4F1B5.80500@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202237.23174.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 17:03:01 e9hack wrote:
> Am 20.3.2010 15:20, schrieb Hans Verkuil:
> > Hartmut, is the problem with unloading the module something that my patch
> > caused? Or was that there as well before changeset 14351:2eda2bcc8d6f?
> > Are there any kernel messages indicating why it won't unload?
> 
> Changset 14351:2eda2bcc8d6f causes a kernel oops during unload of the module for my dvb
> cards.

OK, I know that. But does the patch I mailed you last time fix this problem
without causing new ones? If so, then I'll post that patch to the list.

Regards,

	Hans

> The call trace points to dvb_ttpci. I assumed, that the FF card is affected only.
> It may be possible, that budget-av does crash also, if it is unload as second.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
