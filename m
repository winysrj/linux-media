Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+52724878713acdb01da0+1929+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1L8H3A-0008AT-64
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 17:27:36 +0100
Date: Thu, 4 Dec 2008 14:27:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "leo theGreat" <leo.thealmighty@gmail.com>
Message-ID: <20081204142721.1c794691@pedra.chehab.org>
In-Reply-To: <401cfcb70812031838r613d8182wa12f2bed5041a999@mail.gmail.com>
References: <401cfcb70812031838r613d8182wa12f2bed5041a999@mail.gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] tm6010 - Compiles All Drivers,
 but not tm6010 Strange!
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

On Thu, 4 Dec 2008 08:08:55 +0530
"leo theGreat" <leo.thealmighty@gmail.com> wrote:

> Hi Everbody,
> 
> I tried to compile the drivers from
> 'http://linuxtv.org/hg/~mchehab/tm6010/<http://linuxtv.org/hg/%7Emchehab/tm6010/>
> '.
> 
> I tried 4 days ago archive..... 5 weeks old and 7 months old... all the same
> results.
> 
> All drivers compile fine... but not tm6000. Compilation runs fine. It
> produces around 200+ drivers but not any tm6000 driver. Although tm6000
> folder is present in all of these archives. But it remains as source file
> only ( like .c, .h etc ) and doesnt get compiled into the driver like other
> drivers. As the compilation goes fine without any errors. I am wondering If
> I am doing something wrong or is there a different way to do it.
> 
> I use 'make' or sometimes 'make all' and then 'make install'.
> 
> According to Mark Breddemann's ( on this Mailing List ) post he has
> successfully compiled these drivers. Kindly guide me the way also. I know
> these drivers are still in the development. But analog support is working.
> And i need only that. My Chipset is Trident TV Master  5600 AI.
> Kindly help me out! Hope to get a reply soon. :)

You need to do "make menuconfig" and select tm6000. 

I'm currently working on the driver and I'll probably merge soon a version with
analog support working fine, including the tm6000-alsa module. The current
version has no sound, and have a serious issue on analog handling, causing
kernel hangs.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
