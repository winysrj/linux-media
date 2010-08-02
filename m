Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62946 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0HBTlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 15:41:37 -0400
Received: by qwh6 with SMTP id 6so1798963qwh.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 12:41:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100731235403.1210e666@pedra>
References: <cover.1280630041.git.mchehab@redhat.com>
	<20100731235403.1210e666@pedra>
Date: Mon, 2 Aug 2010 15:41:35 -0400
Message-ID: <AANLkTim1WPhYA0_LZDWe_LKrUiZg=S7czaQy4JFtUXUH@mail.gmail.com>
Subject: Re: [PATCH 2/7] V4L/DVB: dvb-usb: get rid of struct dvb_usb_rc_key
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 31, 2010 at 10:54 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> dvb-usb has its own IR handle code. Now that we have a Remote
> Controller subsystem, we should start using it. So, remove this
> struct, in favor of the similar struct defined at the RC subsystem.
>
> This is a big, but trivial patch. It is a 3 line delect, plus
> lots of rename on several dvb-usb files.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
