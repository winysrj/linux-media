Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58650 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1JYTNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 15:13:51 -0400
Received: by gyb13 with SMTP id 13so808627gyb.19
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 12:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA6F5C6.7080607@mlbassoc.com>
References: <4EA6F5C6.7080607@mlbassoc.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Tue, 25 Oct 2011 21:13:30 +0200
Message-ID: <CAAwP0s245h=49HM8HO0-29ZAV0DRYowcS9ms46Z0Afm2rs1w2w@mail.gmail.com>
Subject: Re: Starting OMAP3 ISP as module
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 25, 2011 at 7:45 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> To date, I've only been using the OMAP3 ISP + Media Controller Framework
> builtin to the kernel.  Now I'd like to try it as a set of modules, but
> I can't seem to get it to fire up.
>
> What the module insert/probe sequence should I use?
> Any other hints?
>

Hi Gary,

You have to first insert the iommu2 module.

This sequence works:

$ modprobe iommu2
$ modprobe omap3-isp

> Thanks
>
> --

Hope it helps,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
