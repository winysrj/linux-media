Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jc8Vy-0004eg-Ph
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 01:20:19 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 20 Mar 2008 00:48:14 +0100
References: <1115343012.20080318233620@a-j.ru>
In-Reply-To: <1115343012.20080318233620@a-j.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803200048.15063@orion.escape-edv.de>
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Andrew Junev wrote:
> Hello All,
> 
> I was successfully using two TT S-1401 DVB-S cards in my HTPC running
> Fedora 8. One of my antennas is positioned to Astra 19.2E and its
> signal quality is quite low in my area. But the setup worked just fine
> for me most of the time.
> 
> Last weekend I updated my system from kernel-2.6.23.15-137.fc8 to
> kernel-2.6.24.3-12.fc8. It was just a 'yum update', nothing else.
> Right after that I got no lock on most of Astra transponders (other
> satellites were still Ok, but they normally have a far better signal).
> After checking everything twice without any success, I booted back to
> 2.6.23.15 and my Astra was back!
> 
> Is this a known behavior? I suppose it was not discussed before, so
> this makes me think I am the only one with such a problem...
> Strange... I think the problem is somehow related to the signal level / 
> signal error rate. Looks like weak transponders are harder to lock
> with the new kernel...
> I'd appreciate any comments on this. I don't think I have an urgent
> need to move to 2.6.24 now, but I'd still like to be able to do that
> without loosing my TV... 
> 
> 
> P.S. I can see there's kernel-2.6.24.3-34.fc8 already available for
> Fedora 8. But I didn't try it yet...

Afaik this is a known regression in 2.6,24.

See 
  http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023477.html
and
  http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023559.html
for the fix.

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
