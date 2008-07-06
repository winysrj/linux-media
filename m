Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KFJHZ-00014b-MC
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 03:43:22 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 6 Jul 2008 03:42:04 +0200
References: <200807042146.26204.jan@codejunky.org>
In-Reply-To: <200807042146.26204.jan@codejunky.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807060342.04968@orion.escape-edv.de>
Subject: Re: [linux-dvb] Cinergy 1200 DVB-C unsupported device
Reply-To: linux-dvb@linuxtv.org
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

Jan Meier wrote:
> Hello,
> 
> I have a cinergy 1200 DVB-C card which is not supprted by the current driver 
> from the mercurial repository. lspci -vnn shows the following:
> 
> Subsystem: TERRATEC Electronic GmbH Unknown device [153b:a156]
> 
> The device with the device string 153b:1156 is supported, so I hacked around 
> in budget.c/budget-av.c and added a156 instead of 1156, and now the device is 
> found: 

The id 153b:a156 looks suspicious.

Are you sure that the device is properly seated in the pci slot?
If possible, you should also try a different slot.

If this does not help, the subsystem id has very likely been overwritten.
You might re-program the correct id 153b:1156 with the tool fix_eeprom:
http://www.escape-edv.de/endriss/dvb/fix_eeprom.c

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
