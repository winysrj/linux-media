Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33779 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbFHEmq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 00:42:46 -0400
Received: by pdjn11 with SMTP id n11so56559691pdj.0
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2015 21:42:46 -0700 (PDT)
Received: from [10.16.129.137] (napt.igel.co.jp. [219.106.231.132])
        by mx.google.com with ESMTPSA id s1sm1005566pda.54.2015.06.07.21.42.43
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jun 2015 21:42:44 -0700 (PDT)
Message-ID: <55751D44.6010102@igel.co.jp>
Date: Mon, 08 Jun 2015 13:42:44 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Reply-To: Damian Hobson-Garcia <dhobsong@igel.co.jp>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2 codecs in user space
References: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc>
In-Reply-To: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

On 2015-06-02 10:40 AM, Damian Hobson-Garcia wrote:
> Hello All,
> 
> I would like to ask for some comments about a plan to use user space
> video codecs through the V4L interface.  I am thinking of a situation
> similar to the one described on the linuxtv.org wiki at
> http://www.linuxtv.org/wiki/index.php/V4L2_Userspace_Library
> 
> The basic premise is to use a FUSE-like driver to connect the standard
> V4L2 api to a user space daemon that will work as an mem-to-mem driver
> for decoding/encoding, compression/decompression and the like.  This
> allows for codecs that are either partially or wholly implemented in
> user space to be exposed through the standard kernel interface.
> 
> Before I dive in to implementing this I was hoping to get some comments
> regarding the following:
> 
> 1. I haven't been able to find any implementation of the design
> described in the wiki page.  Would anyone know if I have missed it? 
> Does this exist somewhere, even in part? It seems like that might be a
> good place to start if possible.
> 
> 2. I think that this could be implemented as either an extension to FUSE
> (like CUSE) or as a V4L2 device driver (that forwards requests through
> the FUSE API).  I think that the V4L2  device driver would be
> sufficient, but would the fact that there is no specific hardware tied
> to it be an issue?  Should it instead be presented as a more generic
> device?
> 
> 3. And of course anything else that comes to mind.

I've been advised that implementing kernel APIs is userspace is probably
not the most linux-friendly way to go about things and would most likely
not be accepted into the kernel.  I can see the logic of
that statement, but I was wondering if I could confirm that here. Is
this type of design a bad idea?

Also, if this method is not recommended, should there be a 1-2 line
disclaimer on the "V4L2_Userspace_Library" wiki page that mentions this?

Thank you,
Damian
