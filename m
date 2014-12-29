Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.sscnet.ucla.edu ([128.97.229.230]:39801 "EHLO
	smtp0.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaL2UKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Dec 2014 15:10:03 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp0.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id sBTKA2CP027180
	for <linux-media@vger.kernel.org>; Mon, 29 Dec 2014 12:10:02 -0800
Received: from smtp0.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp0.sscnet.ucla.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k0d9XDBDIXn4 for <linux-media@vger.kernel.org>;
	Mon, 29 Dec 2014 12:09:31 -0800 (PST)
Received: from [192.168.1.118] (cpe-75-82-149-146.socal.res.rr.com [75.82.149.146])
	(authenticated bits=0)
	by smtp0.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id sBTK9Rjt027146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 29 Dec 2014 12:09:28 -0800
Message-ID: <54A1B4FD.70006@cogweb.net>
Date: Mon, 29 Dec 2014 12:09:33 -0800
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvbv5-scan needs which channel file?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Greetings --

How do you actually use dvbv5-scan? It seems to require some kind of 
input file but there is no man page and the --help screen doesn't say 
anything about it.

Could we document this? I tried

$ dvbv5-scan
Usage: dvbv5-scan [OPTION...] <initial file>
scan DVB services using the channel file

What is "the channel file"? Maybe the channels.conf file? (I created 
mine using "w_scan -ft -A3 -X -cUS -o7 -a /dev/dvb/adapter0/")

$ dvbv5-scan /etc/channels.conf
ERROR key/value without a channel group while parsing line 1 of 
/etc/channels.conf

So it knows what it wants -- but what is it? Or is this a matter of dvb 
versions, and my /etc/channels.conf is in the older format?

Very mysterious.

Cheers,
David
