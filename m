Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f106.mail.ru ([194.67.57.205])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JVhdg-0000rC-Rx
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 07:25:36 +0100
From: Igor <goga777@bk.ru>
To: Michael Curtis <michael.curtis@glcweb.co.uk>
Mime-Version: 1.0
Date: Sun, 02 Mar 2008 09:25:03 +0300
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D1023979@w2k3sbs.glcdomain.local>
References: <A33C77E06C9E924F8E6D796CA3D635D1023979@w2k3sbs.glcdomain.local>
Message-Id: <E1JVhd9-00005o-00.goga777-bk-ru@f106.mail.ru>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] =?koi8-r?b?bWFrZSBlcnJvcnMgbXVsdGlwcm90bw==?=
Reply-To: Igor <goga777@bk.ru>
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

> Manu, I do not understand your response

other words - you can forget about this warnings (not errors)


> I am using the TT3200 and so the stb0899 module will be required
> 
> I cannot see how make menuconfig can disable the stb0899 module as it is not a recognised module in 2.6.23.137
> 
> Although if I ignore the errors, the modules appear to compile and then load

fine.

> But then the best I can get with with zapping using your modified szap is
> 
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 0060 | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe | FE_HAS_LOCK status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe | FE_HAS_LOCK
> 
> I need to know if I am on the right track or those compile errors are having an influence on the performance of the TT3200 frontend

yes, you on the right track and you can continue your tests wit TT3200


> The signal strength should be >50-60% and quality >80%

please mean - szap2 shows the dB in hex.

Igor



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
