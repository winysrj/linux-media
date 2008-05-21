Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n30.bullet.mail.ukl.yahoo.com ([87.248.110.147])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JytLK-0004uM-GK
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 20:47:19 +0200
Date: Wed, 21 May 2008 14:46:38 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <4833D91A.1050101@kipdola.com>
In-Reply-To: <4833D91A.1050101@kipdola.com> (from skerit@kipdola.com on Wed
	May 21 04:11:06 2008)
Message-Id: <1211395598l.5771l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : TT S2-3200 LIRC remote - Multiproto drivers merge?
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

On 05/21/2008 04:11:06 AM, Jelle De Loecker wrote:
> Hello again,
> 
> I finally got the Technotrend S2-3200 to work on LinuxMCE 0710, now
> I'm 
> wondering how to get the IR transceiver to work. (Not that I've
> managed 
> to get mythtv working, but since activity on that subject is a bit 
> slower...)
> 
> I already tried to ask on the lirc mailing list, but it seems like a 
> very dead place.
> 
> My dmesg output proves the transceiver is discovered and I have a 
> /dev/class/input kind of file, I just don't know how to get lirc to 
> work, or how to get a /dev/lirc0 file (I actually already have 
> another
> 
> transceiver on this computer which apparantly only works with MCE 
> remotes (it's an integrated IR transceiver in my Antec Fusion v2
> case)) 
> since there isn't a specific driver in lirc for this technotrend 
> card.
> 
> Now, I want to get some facts straight about the multiproto driver:
> Is it "done"? What's the big difference between multiproto and 
> multiproto plus? (Even though there hasn't been an update in 5 weeks
> for 
> the regular drivers, the plus drivers seemed to have more activity)
> 
> Or is it correct to assume that now only the software applications
> need 
> to get a patch to work with our multiproto drivers?
> 
> And, looking at the multiproto_plus drivers, I see they "merged" with 
> v4l-dvb - what does this mean exactly?
> 

I have a patch to make it work, I will post it on the list in a short 
while.
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
