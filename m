Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n36.bullet.mail.ukl.yahoo.com ([87.248.110.169])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JbS18-0003ej-BP
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 03:57:37 +0100
Date: Mon, 17 Mar 2008 22:02:23 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
In-Reply-To: <47D96A9A.9040204@gmail.com> (from abraham.manu@gmail.com on
	Thu Mar 13 13:55:38 2008)
Message-Id: <1205805743l.11520l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: [linux-dvb] Re :  Re : TT S2-3200 vlc streaming
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

On 03/13/2008 01:55:38 PM, Manu Abraham wrote:
> manu wrote:
> > On 03/11/2008 02:27:31 AM, Vladimir Prudnikov wrote:
> >> I'm getting late buffers with vlc on some transponders (DVB-S, 
> same
>  
> >> parameters, good signal guaranteed) while everything is fine with  
> >> others. Using multiproto and TT S2-3200.
> >> Anyone having same problems?
> > 
> > Can you give the frequencies of the good and bad transponders, mine
> are 
> > as follows:
> > I can receive from 4 transponders (DVB-S): 11093, 11555, 11635,
> 11675 
> > MHz.
> > any channel on 11093: fast lock, perfect picture.
> > any channel on 11555: lock a bit slower and corrupted stream (lots
> of 
> > blocky artifacts, myhttv complains about corrupted stream)
> > any channel on 11635,11675: no lock.
> 
> Please provide:
> 
> * parameters that you use for tuning each of these transponders
> * logs from the stb0899 and stb6100 modules both loaded with
> verbose=5,
> for each of these transponders
> 
> Hope it might shed some light into your problems.

hmm actually it appears to be rather difficult: in mythtv I sometimes 
get the bad channels with a perfect picture whereas the good ones are 
always good.
Even szap gives me unreliable results: sometimes szap won't lock and 
next time I have a solid lock (I can't test the picture though as every 
channel is encrypted).
But I have seen something: all the unrelaible frequencies 
(11555,11635,11675MHz) are very close to the 11700MHz Universal lnb 
switch frequency, whereas the good one is very far (11093MHz).
Could that be a lead to the root of the problem?
I am still testing and trying to get some useful logs.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
