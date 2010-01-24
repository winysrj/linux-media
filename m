Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59101 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0AXMTS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 07:19:18 -0500
Message-ID: <4B5C3ABF.4000807@iki.fi>
Date: Sun, 24 Jan 2010 14:19:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Moore <moore@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Looking for original source of an old DVB tree
References: <4B5BFFE3.30003@free.fr>
In-Reply-To: <4B5BFFE3.30003@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/24/2010 10:08 AM, Chris Moore wrote:
> Hello,
>
> Short version:
> I am looking for the original source code of a Linux DVB tree containing
> in particular
> drivers/media/dvb/dibusb/microtune_mt2060.c
> and the directory
> drivers/media/dvb/dibusb/mt2060_api
>
> Googling for microtune_mt2060.c and mt2060_api is no help.
> Could anyone kindly point me in the right direction, please?

It is mt2060.c, mt2060_priv.h (IIRC) and mt2060.h.

> Longer version:
> I am trying to get my USB DVB-T stick running on my Xtreamer.
> Xtreamer uses an old 2.6.12.6 kernel heavily modified by Realtek and
> possibly also modified by MIPS.
> I have the source code but it would be a tremendous effort to change to
> a recent kernel.
> The DVB subtree seems to have been dirtily hacked by Realtek to support
> their frontends.
> In the process they seem to have lost support for other frontends.
> I have been trying to find the source code for the original version.
> I have found nothing resembling it in kernel.org, linux-mips.org and
> linuxtv.org.

I am not sure what kind of device Xtreamer is, but try this:
http://linuxtv.org/hg/~anttip/rtl2831u/

It is for Realtek RTL2831U + MT2060 based USB sticks.

regards
Antti
-- 
http://palosaari.fi/
