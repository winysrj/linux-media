Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:39364 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZLaMqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 07:46:51 -0500
Received: by qyk30 with SMTP id 30so5897734qyk.33
        for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 04:46:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260637174.3085.3.camel@palomino.walls.org>
References: <200912120230.36902.liplianin@me.by>
	 <200912121349.58436.liplianin@me.by>
	 <1260627327.3104.13.camel@palomino.walls.org>
	 <200912121822.01184.liplianin@me.by>
	 <1260637174.3085.3.camel@palomino.walls.org>
Date: Thu, 31 Dec 2009 13:46:49 +0100
Message-ID: <59335d7a0912310446q9b457a3u5cba0f60dfdd009e@mail.gmail.com>
Subject: Re: IR Receiver on an Tevii S470
From: =?ISO-8859-1?Q?Guillem_Sol=E0_Aranda?= <garanda@flumotion.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a s470 and with

s2-liplianin-7212833be10d
s2-liplianin-ab3a80e883ba

began to work, but today I have tested

s2-liplianin-b663b38d616f

and seems that there are some problems trying to load the driver

Linux video capture interface: v2.00
cx23885: disagrees about version of symbol ir_codes_hauppauge_new_table
cx23885: Unknown symbol ir_codes_hauppauge_new_table
cx23885: disagrees about version of symbol ir_input_init
cx23885: Unknown symbol ir_input_init
cx23885: disagrees about version of symbol ir_input_nokey
cx23885: Unknown symbol ir_input_nokey
cx23885: disagrees about version of symbol ir_input_keydown
cx23885: Unknown symbol ir_input_keydown

I'm running this on a DELL Server with RHEL and kernel 2.6.31.

regards,
Guillem
