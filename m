Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n37.bullet.mail.ukl.yahoo.com ([87.248.110.170])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JcVQV-0001PZ-9d
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 01:48:07 +0100
Date: Thu, 20 Mar 2008 20:47:17 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <47E2FBD2.2080305@konto.pl>
In-Reply-To: <47E2FBD2.2080305@konto.pl> (from gasiu@konto.pl on Thu Mar 20
	20:05:38 2008)
Message-Id: <1206060438l.15799l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Multiproto szap lock, but video file is empty
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

On 03/20/2008 08:05:38 PM, Gasiu wrote:
> i've got SkystarHD, Ubuntu64 and multiproto-ecb96c96a69e - after 
> patching szap.c
> 
> I can szap a channel:
> 
>  ./szap polsat2

Try

szap -r polsat2
    ^^^

Also if the channels are encrypted you need another util to control the 
CI/CAM
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
