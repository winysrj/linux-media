Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35003 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbJUT2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 15:28:36 -0400
Received: by lffy185 with SMTP id y185so26031488lff.2
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2015 12:28:34 -0700 (PDT)
Received: from [192.168.100.28] (a88-115-254-86.elisa-laajakaista.fi. [88.115.254.86])
        by smtp.gmail.com with ESMTPSA id a188sm1732222lfa.9.2015.10.21.12.28.33
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2015 12:28:33 -0700 (PDT)
Subject: Re: Trying to get Terratec Cinergy T XS to work
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <56267512.6080207@users.sourceforge.net>
From: Alberto Mardegan <mardy@users.sourceforge.net>
Message-ID: <5627E760.6030806@users.sourceforge.net>
Date: Wed, 21 Oct 2015 22:28:32 +0300
MIME-Version: 1.0
In-Reply-To: <56267512.6080207@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to another developer, I've made some progress and loaded the
driver with the right tuner (mt2060). The /dev/dvb/* nodes are created.

Now the problem is that when I run a scan, the mt2060_set_params()
function is not called at all [1].
I've set the "debug" and "frontend_debug" flags to 1, but I don't see
any kernel messages when I'm scanning. (I'm using the "scan" command)

Can please someone guide me a bit to debug this?

Ciao,
  Alberto


[1]: I can tell that because I'se set the "debug=1" option on the mt2060
module, and I can indeed see some other debugging stuff when that module
is initialized, but the debug lines from the set_params() method are not
printed.


-- 
http://blog.mardy.it <- geek in un lingua international!
