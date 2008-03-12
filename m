Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n34.bullet.mail.ukl.yahoo.com ([87.248.110.167])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JZQ86-0003KF-9e
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 13:32:22 +0100
Date: Wed, 12 Mar 2008 08:29:15 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <3320EBAB-1EFE-4038-BCFD-D218701A8AF1@krastelcom.ru> (from
	vpr@krastelcom.ru on Tue Mar 11 02:27:31 2008)
Message-Id: <1205324955l.5684l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  TT S2-3200 vlc streaming
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

On 03/11/2008 02:27:31 AM, Vladimir Prudnikov wrote:
> I'm getting late buffers with vlc on some transponders (DVB-S, same  
> parameters, good signal guaranteed) while everything is fine with  
> others. Using multiproto and TT S2-3200.
> Anyone having same problems?

Can you give the frequencies of the good and bad transponders, mine are 
as follows:
I can receive from 4 transponders (DVB-S): 11093, 11555, 11635, 11675 
MHz.
any channel on 11093: fast lock, perfect picture.
any channel on 11555: lock a bit slower and corrupted stream (lots of 
blocky artifacts, myhttv complains about corrupted stream)
any channel on 11635,11675: no lock.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
