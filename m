Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KM16H-0004qm-1W
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 15:43:22 +0200
Message-ID: <48888700.6030105@iinet.net.au>
Date: Thu, 24 Jul 2008 21:43:28 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: tobi@to-st.de, Nico Sabbi <Nicola.Sabbi@poste.it>,
	linux-dvb@linuxtv.org, stephen@rowles.org.uk
Subject: Re: [linux-dvb] dvb mpeg2?
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

Hi all,

Got there:

Filetype is MPEG2-TS (generic PES Container)

Need to use mplayer, projectx to ascertain this.

This is what I have just done to achieve an a/v sync perfect, edited, 
recorded dvb file:

1. Run file through project-x; divides files into *.mp2 (MPEG audio 
stream), *.m2v (video stream),
   (plus for HDTV *.ac3 (for Dolby Digital aka AC3 stream))
projectx rec-file.mpeg => rec-file.m2v rec-file.mp2

2. Run *.mp2 *.m2v through mplex to recombine into PS format
mplex -f 8 -o rec-file-a.mpeg rec-file.m2v rec-file.mp2 => rec-file-a.mpeg

3. Edit resultant file with avidemux on I-Frames while retaining a/v 
sync => rec-file-a-a.mpeg

And it produces a perfect new file!

My huge thanks to you all for your assistance.

Regards,
Tim Farrington

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
