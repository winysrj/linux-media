Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0195.b.hostedemail.com ([64.98.42.195]:59754 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755015Ab2JVRaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 13:30:39 -0400
Date: Mon, 22 Oct 2012 17:30:37 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: stern@rowland.harvard.edu
Cc: zonque@gmail.com, bp@alien8.de, pavel@ucw.cz,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	security@kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <1985645001.39510.1350927037793.JavaMail.mail@webmail15>
References: <Pine.LNX.4.44L0.1210221153140.1724-100000@iolanthe.rowland.org>
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 22, 2012, Alan Stern <stern@rowland.harvard.edu> wrote: 

> A BUG() at these points would crash the machine hard.  And where we
> came from doesn't matter; what matters is the values in the pointers.

OK, here's what the kernel prints with your patch:

usb 6.1.4: ep 86 list del corruption prev: e5103b54 e5103a94 e51039d4

A small delay before I got thousands of list_del corruption messages would
have been nice, but I managed to catch the message anyway.

Artem

