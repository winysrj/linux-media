Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n79.bullet.mail.sp1.yahoo.com ([98.136.44.39])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KZiQ9-0007O9-U3
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 10:36:31 +0200
Date: Sun, 31 Aug 2008 01:35:51 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Goga777 <goga777@bk.ru>
In-Reply-To: <20080830213831.7b8e2c42@bk.ru>
MIME-Version: 1.0
Message-ID: <195222.73778.qm@web46109.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] cat: /dev/dvb/adapter0/dvr0: Value too large for
	defined data type
Reply-To: free_beer_for_all@yahoo.com
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

--- On Sat, 8/30/08, Goga777 <goga777@bk.ru> wrote:

> "cat: /dev/dvb/adapter0/dvr0: Value too large for
> defined data type"
> 
> is it possible to fix it ?

This is a result of error EOVERFLOW.

I found mention of this in some very old documentation I have
but which doesn't appear to be present in the very limited
searching I've done on the existing source repositories.

I also can't find a particular pointer I read years back, which
led me to tweak the value of DVB_BUFFER_SIZE in dvb-core/dmxdev.h
so solve some problem I can't remember.

The documentation points to DMX_SET_BUFFER_SIZE.  Programs like
`szap' seem to set this to 64k.

Hope that gets you started in the right direction...


barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
