Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JzeKR-0004ki-4m
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 22:57:32 +0200
From: Nicolas Will <nico@youplala.net>
To: kafifi <kafifi@orange.fr>
In-Reply-To: <20080523203702.4F21C800010B@mwinf2807.orange.fr>
References: <20080523203702.4F21C800010B@mwinf2807.orange.fr>
Date: Fri, 23 May 2008 21:56:22 +0100
Message-Id: <1211576182.26119.12.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NOVA-T500 : mesuring bit rate error ?
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

On Fri, 2008-05-23 at 22:36 +0200, kafifi wrote:
> Hello,
> 
> I recently added a NOVA-T500 to my vdrbox. Unfortunately, even if the
> picture is really nice, I've some freezes because the DVB-T signal is weak
> (I am in 50km of the Eiffel Tower...).


Ah ah ! Un compatriote!



>  I ordered a 0.4 dB low noise
> preamplifier (ULNA 3036 from TGN-Technology) to improve my installation. 


Just make sure that you install it as close to the antenna as possible,
on the mast.


> 
> I will need to mesure strengh and bit rate error values. Unfortunately,
> Femon 1.6 is mesuring only the strengh value (about 60%). It seems the DVB
> driver of Nova-T 500 always returns 0. 


It does not, or at least it did not when using a v4l-dvb tree from
around February. 

================================================================================
Tunning channel tvtv DIGITAL (634000000)
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 634000000 Hz
video pid 0x0000, audio pid 0x0000
Signal: 41%	BER 2097151	UNC 44
Signal: 41%	BER 4240	UNC 0
Signal: 40%	BER 5872	UNC 0
Signal: 40%	BER 4928	UNC 0
Signal: 41%	BER 2848	UNC 0
Signal: 40%	BER 5344	UNC 0
Signal: 40%	BER 8304	UNC 0
Signal: 41%	BER 3232	UNC 0
Signal: 41%	BER 3264	UNC 0
Signal: 41%	BER 4288	UNC 0

================================================================================
Tunning channel Sky Text (634000000)
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 634000000 Hz
video pid 0x0000, audio pid 0x0000
Signal: 41%	BER 2097151	UNC 0
Signal: 41%	BER 3072	UNC 15
Signal: 40%	BER 2944	UNC 0
Signal: 41%	BER 2688	UNC 0
Signal: 40%	BER 6880	UNC 0
Signal: 41%	BER 7280	UNC 0
Signal: 41%	BER 3744	UNC 0
Signal: 40%	BER 7168	UNC 0
Signal: 39%	BER 4160	UNC 0
Signal: 40%	BER 4304	UNC 0

================================================================================
Tunning channel Virgin Radio (634000000)
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 634000000 Hz
video pid 0x0000, audio pid 0x076d
Signal: 41%	BER 2097151	UNC 0
Signal: 41%	BER 3520	UNC 0
Signal: 41%	BER 6384	UNC 0
Signal: 41%	BER 4128	UNC 0
Signal: 41%	BER 6128	UNC 0
Signal: 40%	BER 8560	UNC 0
Signal: 41%	BER 5856	UNC 0
Signal: 40%	BER 7968	UNC 0
Signal: 41%	BER 7664	UNC 0
Signal: 41%	BER 11824	UNC 0

This was generated on my Nova-T-500 before I got a low-noise masthead
amp:

http://www.youplala.net/~will/htpc/signaltest/

I used the following scripts to generate this:

http://www.linuxtv.org/wiki/index.php/Testing_reception_quality

Maybe femon has an issue, though, as those scripts do not use it.

Nico
http://www.youplala.net/linux/home-theater-pc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
