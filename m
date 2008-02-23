Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1JSsTO-0005vc-Ao
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 12:23:18 +0100
Message-Id: <7543B999-C26B-46A9-929D-C5CA625A131A@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
In-Reply-To: <47BFD5F4.3030805@shikadi.net>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 23 Feb 2008 21:22:44 +1000
References: <47BFD5F4.3030805@shikadi.net>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Is there a daemon style program for scheduled DVB
 recording?
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


On 23 Feb 2008, at 18:14, Adam Nielsen wrote:

> If you were setting up a headless machine to record TV shows, what
> programs would you use to do this?  Ideally I'd like the shows dumped
> into a local directory, so that I can watch them over NFS with  
> mplayer,
> but I'm open to alternatives.
>
> I really want to avoid running a whole "media centre" program like
> MythTV, VDR, etc. as I'd like this to be lean and clean and I don't  
> mind
> using the command line for playback.


Obviously, you seem to have never actually tried VDR. It's extremely  
lean and clean and it don't need to run with any output. You can  
telnet into it and schedule recordings and it's easy to view  
recordings over NFS, or use a streaming media client directly towards  
VDR with a suitable streaming plugin.


-- 
Torgeir Veimo
torgeir@pobox.com




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
