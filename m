Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KiX4I-0008R8-Ts
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 18:18:25 +0200
From: Darron Broad <darron@kewl.org>
To: Anders Semb Hermansen <anders@ginandtonic.no>
In-reply-to: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no> 
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
Date: Wed, 24 Sep 2008 17:18:19 +0100
Message-ID: <5584.1222273099@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>, Anders Semb Hermansen wrote:
>Hello all,

hi.

>I put a HVR-4000 in my mythtv box, I'm only going to use it for  
>analogue TV right now.
>
>I have used dvb/v4l drivers from mercirual from yesterday and sfe-8969- 
>untested.diff from http://dev.kewl.org/hauppauge/ to get HVR-4000  
>support.
>
>The system is Debian GNU/Linux lenny with latest packages and kernel  
>updated yesterday. Mythtv and multimedia packages are from debian- 
>multimedia.
>
>I also get the same error described below when using dvb/v4l driver  
>from http://linuxtv.org/hg/~stoth/s2-mfe
>
>I added it as a v4l capture card in mythtv (/dev/video0 and sound  
>from /dev/dsp2) and scanned for channels. Everything OK so far :)
>
>When I use mythtv and go into "Watch TV" I get snow on the screen (and  
>some green). If I change channel the picture comes up fine. So I  
>always have to change channel after pressing "Watch TV". This will  
>make recodings only show snow, because I cannot do the channel change  
>"trick".
>
>I got strange audio, but read somewhere else that I needed to change  
>audo samplerate to 48000. That fixed that problem.
>
>I get some errors from the kernel.
<snip>

I haven't tested analogue in mythtv, only dvb-s. My only testing has been
done with TVTIME for analogue. What happens when you try that?

cya.


--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
