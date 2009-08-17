Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:48351 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZHQXI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 19:08:56 -0400
Received: by rv-out-0506.google.com with SMTP id f6so869545rvb.1
        for <linux-media@vger.kernel.org>; Mon, 17 Aug 2009 16:08:58 -0700 (PDT)
Date: Mon, 17 Aug 2009 14:20:40 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, jayakumar.lkml@gmail.com, mag@mag.cx,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] quickcam_messenger.c: add support for all quickcam
 Messengers of the same family
Message-ID: <20090817212040.GZ21546@jenkins.home.ifup.org>
References: <20081202223854.GA5770@jenkins.ifup.org>
 <20090808012135.GA11251@jenkins.home.ifup.org>
 <20090816213350.2cee217b@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816213350.2cee217b@caramujo.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21:33 Sun 16 Aug 2009, Mauro Carvalho Chehab wrote:
> Could you please check if stv06xx.c is properly working with those devices?
> Feel free to submit patches improving it, if needed.

Alright, I asked the two users who reported the bug to test
gspca_stv06xx.ko also. I will let you know how that goes.

Cheers,

	Brandon
