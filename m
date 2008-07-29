Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp4.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1KNwTv-0001xw-MW
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 23:11:48 +0200
Message-ID: <488F8760.4010703@avalpa.com>
Date: Tue, 29 Jul 2008 23:10:56 +0200
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.5.1217347135.25488.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.5.1217347135.25488.linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------030006050305080602060506"
Subject: Re: [linux-dvb] Where I can get the open sofware to play TS file?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030006050305080602060506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[sorry if i break the thread but i read this list in a digest form..]

>
> Subject:
> [linux-dvb] Where I can get the open sofware to play TS file?
> From:
> loody <miloody@gmail.com>
> Date:
> Tue, 29 Jul 2008 20:38:33 +0800
> To:
> linux-dvb@linuxtv.org
>
> To:
> linux-dvb@linuxtv.org
>
>
> Dear all:
> I study 13818-1 recently, but I cannot understand the whole flow of
> PCR, PTS and DTS.
>   
as nico already told you, this PCR is the "tick" information that sync 
remote decoders to the clock inside the source (the TS player).

then, DTS and PTS are timestamps on every frames with which the decoder 
decide when decode or present each single frame.
the tough problem is that in a "real decoder" (aka cheap, crappy or 
whatever..) you have though constraints on the buffer so you need to act 
quickly otherwise you'll occur in underrun and overrun of these buffers, 
i.e. artifacts (blocking freeze) on the screen.. (it depends on the 
concealment techniques implemented..)

if you play a Ts in a "fatty" PC, with huge buffers, you don't mind to 
be so picky in the PCR recovery so VLC and MPLAYER don't need to cope so 
much to give a reasonable quality (albeit latency increases).

if you want, you can get some interesting tools to study PCR creation 
and test something, multiplexing remultiplexing, on real TS (if you can 
get them from the air..).

i work in Avalpa, a company developing a free (GPL) software toolbox for 
digital television management, OpenCaster (formerly JustDvb-It), you can 
get it here:

  
http://www.avalpa.com/component/content/article/12-newsflash/35-opencaster-ver10-release-today-2062008

this toolbox is composed of something like 10 different basic utitilities.
putting them together, you cold achieve a great number of services for 
(interactive) digital television..

you should focus on "tsstamp" and "tspcmeasure", these are related to PCR.

hope that helps. let me know if you have more questions.

bye

andrea venturi




> Would someone please tell me where I can get any open TS-player or
> part of source code which can help me to figure this part out?
> ps:I have check ffmpeg and vcl, and both of them seem cannot play TS directly.
>
> appreciate your help,
> miloody
>
>   


--------------030006050305080602060506
Content-Type: text/x-vcard; charset=utf-8;
 name="a_venturi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a_venturi.vcf"

begin:vcard
fn:Andrea Venturi
n:;Andrea Venturi
org:Avalpa Digital Engineering SRL
adr;dom:;;Via dell'Arcoveggio 49/5;Bologna;BO;40129
email;internet:a.venturi@avalpa.com
title:CEO
tel;work:+39 0514187531
tel;cell:+39 3477142994
url:www.avalpa.com
version:2.1
end:vcard


--------------030006050305080602060506
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030006050305080602060506--
