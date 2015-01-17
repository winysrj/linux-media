Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39257 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbbAQNXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2015 08:23:50 -0500
Received: by mail-qg0-f45.google.com with SMTP id q107so580452qgd.4
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2015 05:23:49 -0800 (PST)
Date: Sat, 17 Jan 2015 10:23:39 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: Re: [PATCH] media: pci: solo6x10: solo6x10-enc.c:  Remove unused
 function
Message-ID: <20150117102339.5c224564@pirotess.bf.iodev.co.uk>
In-Reply-To: <54B8EE13.6010508@xs4all.nl>
References: <1419184727-11224-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54B8EE13.6010508@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Jan 2015 11:55:15 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:
> (resent with correct email address for Ismael)
> 
> Ismael, Andrey,
> 
> Can you take a look at this? Shouldn't solo_s_jpeg_qp() be hooked up
> to something?

The feature was never implemented, so yes, and we should keep it around.
