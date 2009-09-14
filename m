Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:32658 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZINNcH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 09:32:07 -0400
Received: by qw-out-2122.google.com with SMTP id 9so952122qwb.37
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 06:32:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAD9732.9060003@wilsonet.com>
References: <200909011019.35798.jarod@redhat.com>
	 <1251855051.3926.34.camel@palomino.walls.org>
	 <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>
	 <6EBCDFA3-FAAA-4757-97B6-9CF3442FE920@wilsonet.com>
	 <20090913221314.GA11178@aniel.lan> <4AAD9732.9060003@wilsonet.com>
Date: Mon, 14 Sep 2009 09:32:10 -0400
Message-ID: <de8cad4d0909140632g7e20d501p6ae3d68e5cd30c21@mail.gmail.com>
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Janne Grunau <j@jannau.net>, Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver build procedure used:

Cloned http://hg.jannau.net/hdpvr
Pulled http://linuxtv.org/hg/v4l-dvb/
Pulled http://linuxtv.org/hg/~awalls/v4l-dvb/

This should bring in all changes for HDPVR and CX18.

What specifically would you like me to test? I can't reload the
modules until the kids are done watching TV. :)

Thanks,

Brandon
