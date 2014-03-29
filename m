Return-path: <linux-media-owner@vger.kernel.org>
Received: from Gaia.Eases.nl ([46.182.217.96]:60162 "EHLO Gaia.Eases.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaC2M64 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 08:58:56 -0400
Received: from [10.101.1.101] (D522A8E2.static.ziggozakelijk.nl [213.34.168.226])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by Gaia.Eases.nl (Postfix) with ESMTPSA id 8FDB6692F
	for <linux-media@vger.kernel.org>; Sat, 29 Mar 2014 13:20:07 +0100 (CET)
Message-ID: <5336BA70.2080807@podiumbv.nl>
Date: Sat, 29 Mar 2014 13:20:00 +0100
From: "Podium B.V." <mailinglist@podiumbv.nl>
Reply-To: mailinglist@podiumbv.nl
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: FireDTV / w_scan / no data from NIT(actual)
References: <5336B87A.2010402@podiumbv.nl>
In-Reply-To: <5336B87A.2010402@podiumbv.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

I am new to this mailinglist, but I couldn't find any help in forums
so in the IRC someone suggested to mail my question here.

I am trying to get my FireDTV to tune on a mux so I can generate a 
summary of bitrates
of streams within the mux. So my goal is not to watch Digitale TV on my 
Linux system.

Only is goes already wrong with the init scan.... I only get: "Info: no 
data from NIT(actual)"

I tried to summary all the info here : http://pastebin.com/kSwxBsaU
The OS I'm using is ubuntu 13.10 at the moment and I also tried / installed
the latest build:

cd /usr/src
sudo git clone git://linuxtv.org/media_build.git
sudo ./build
sudo make install
sudo reboot

Does anyone has an idea what I am doing wrong ? Or missing ?
I'm new to DVB-C on Linux.

Kind regards!
Ed



