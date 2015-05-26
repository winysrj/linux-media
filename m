Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:56482 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbEZNLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:11:00 -0400
Date: Tue, 26 May 2015 12:17:25 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 07/20] media: soc_camera: rcar_vin: Add BT.709 24-bit
 RGB888 input support
In-Reply-To: <Pine.LNX.4.64.1505251615220.26358@axis700.grange>
Message-ID: <alpine.DEB.2.02.1505261209030.6402@xk120.dyn.ducie.codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-8-git-send-email-william.towle@codethink.co.uk> <Pine.LNX.4.64.1505251615220.26358@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2015, Guennadi Liakhovetski wrote:
> How about this version of this patch:
>
> https://patchwork.linuxtv.org/patch/28098/
>
> ? I personally like that one better, it seems clearer to me. This one
> first sets a bit to vnmp, then make another check and inverts it, whereas
> that version clearly sets it just for equal colour-spaces. I just never
> got with proper Sob and (maybe?) authorship.

Hi Guennadi,
   Thanks for noticing - we reverted this patch to the version
previously indicated in testing and it didn't get set back.

   We have a test branch for the next version, and I shall attend to
this and the other authorship comments you made immediately.

Thanks,
   Wills.
