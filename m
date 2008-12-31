Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LHopq-0000Z3-J9
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 01:21:19 +0100
Received: by qw-out-2122.google.com with SMTP id 9so2633101qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 16:21:13 -0800 (PST)
Message-ID: <412bdbff0812301621l2f2b8dc3i47f31bf31d481685@mail.gmail.com>
Date: Tue, 30 Dec 2008 19:21:13 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: sonofzev@iinet.net.au
In-Reply-To: <58818.1230682656@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <58818.1230682656@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, Dec 30, 2008 at 7:17 PM, sonofzev@iinet.net.au
<sonofzev@iinet.net.au> wrote:
> Here is the full output from startup  (attached as dmesg.txt) .. the looping
> message in the original email starts immediately after (re ran dmesg after
> writing this file to check)..
> I hope this is useful
>
<snip>

Is this a MythTV system or something that does a scan at startup?

Also, can you provide any timing info as to the frequency of the
messages (some distributions include the time down to the ms in their
dmesg output, but I don't know how that is configured)

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
