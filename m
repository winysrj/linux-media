Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4857BE67.2010208@linuxtv.org>
Date: Tue, 17 Jun 2008 09:38:47 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Brandon Jenkins <bcjenkins@tvwhere.com>
References: <1E35FDF4-8D68-47AA-9DA6-B880879274E2@tvwhere.com>
In-Reply-To: <1E35FDF4-8D68-47AA-9DA6-B880879274E2@tvwhere.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency?
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

Brandon Jenkins wrote:
> Greetings,
> 
> I choose to compile only the modules which are required for the  
> hardware in my system as a way to speed up compilation times. When  
> compiling for the v4l-dvb I run make menuconfig and deselect the  
> modules for the adapters  not in my system. If I don't compile in  
> Simple tuner support the cx18 load process throws and error in tveeprom.


The analog tuner on the hvr1600 is supported by tuner-simple -- you need that module compiled.

-Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
