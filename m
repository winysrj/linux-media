Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:23404 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3G3P3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 11:29:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: Question about v4l2-compliance: cap->readbuffers
Date: Tue, 30 Jul 2013 17:29:26 +0200
Cc: linux-media@vger.kernel.org
References: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com> <201307301545.51529.hverkuil@xs4all.nl> <CAPybu_13HCY1i=tH1krdKGOSbJNgek-X4gt1cGmo_oB=AqTxKg@mail.gmail.com>
In-Reply-To: <CAPybu_13HCY1i=tH1krdKGOSbJNgek-X4gt1cGmo_oB=AqTxKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307301729.26053.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 30 July 2013 17:18:58 Ricardo Ribalda Delgado wrote:
> Thanks for the explanation Hans!
> 
> I finaly manage to pass that one ;)
> 
> Just one more question. Why the compliance test checks if the DISABLED
> flag is on on for qctrls?
> 
> http://git.linuxtv.org/v4l-utils.git/blob/3ae390e54a0ba627c9e74953081560192b996df4:/utils/v4l2-compliance/v4l2-test-controls.cpp#l137
> 
>  137         if (fl & V4L2_CTRL_FLAG_DISABLED)
>  138                 return fail("DISABLED flag set\n");
> 
> Apparently that has been added on:
> http://git.linuxtv.org/v4l-utils.git/commit/0a4d4accea7266d7b5f54dea7ddf46cce8421fbb
> 
> But I have failed to find a reason

It shouldn't be used anymore in drivers. With the control framework there is
no longer any reason to use the DISABLED flag.

If something has a valid use case for it, then I'd like to know what it is.

Regards,

	Hans
