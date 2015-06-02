Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34662 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbbFBBkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 21:40:25 -0400
Received: by payr10 with SMTP id r10so39016325pay.1
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2015 18:40:25 -0700 (PDT)
Received: from [10.16.129.137] (napt.igel.co.jp. [219.106.231.132])
        by mx.google.com with ESMTPSA id p9sm15827697pds.92.2015.06.01.18.40.22
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 01 Jun 2015 18:40:23 -0700 (PDT)
From: "Damian Hobson-Garcia" <dhobsong@igel.co.jp>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] V4L2 codecs in user space
Date: Tue, 02 Jun 2015 01:40:25 +0000
Message-Id: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc>
Reply-To: "Damian Hobson-Garcia" <dhobsong@igel.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

I would like to ask for some comments about a plan to use user space 
video codecs through the V4L interface.  I am thinking of a situation 
similar to the one described on the linuxtv.org wiki at 
http://www.linuxtv.org/wiki/index.php/V4L2_Userspace_Library

The basic premise is to use a FUSE-like driver to connect the standard 
V4L2 api to a user space daemon that will work as an mem-to-mem driver 
for decoding/encoding, compression/decompression and the like.  This 
allows for codecs that are either partially or wholly implemented in 
user space to be exposed through the standard kernel interface.

Before I dive in to implementing this I was hoping to get some comments 
regarding the following:

1. I haven't been able to find any implementation of the design 
described in the wiki page.  Would anyone know if I have missed it?  
Does this exist somewhere, even in part? It seems like that might be a 
good place to start if possible.

2. I think that this could be implemented as either an extension to FUSE 
(like CUSE) or as a V4L2 device driver (that forwards requests through 
the FUSE API).  I think that the V4L2  device driver would be 
sufficient, but would the fact that there is no specific hardware tied 
to it be an issue?  Should it instead be presented as a more generic 
device?

3. And of course anything else that comes to mind.

Thank you,
Damian

