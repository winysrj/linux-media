Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KhMO9-0000RB-Hr
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 12:42:04 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	526F518001BF
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 10:41:25 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Alex Ferrara" <alex@receptiveit.com.au>
Date: Sun, 21 Sep 2008 20:41:25 +1000
Message-Id: <20080921104125.3218916429C@ws1-4.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico dual digital express - Poor tuner
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

> On Sun, Sep 21, 2008 at 3:35 PM, Alex Ferrara <alex@receptiveit.com.au> wrote:
> > I am currently seeing inconsistent performance with the dvico dual
> > digital express. Some channels tune just fine, and others have the
> > impression of a very low signal strength.
> 
> I have the same card in regional Australia, i had a similar problem
> problem, its working fine now though.
> 
> One of my issue was that i had not scanned the channels properly, did
> you generate your initial-tuning-data yourself and use scan to
> generate the channels.conf, or use somebody elses initial-tuning-data
> ?
> 
> It could be that the frequency in your channels.conf isnt accurate
> enough, from what ive experienced if you set the frequency in the
> channels.conf to be the center frequency of channel + 125kHz you
> should be ok.
> 
> Also, there is an app called femon from dvb-apps package which will
> display the signal strength of the currently tunned channel, i just
> started that going and moved my indoor digital antenna around till i
> got max strength.
> 
> 
> Glenn

Alex,

Does this also happen in windows?
If so another possible solution is to either turn down your distribution amplifier or install attenuators on the RF input into the card. 
In my mates setup I had to install a 12db attenuator inline to reduce the signal enough to within the cards dynamic range (An analogy of this is if you are at a rock concert next to the speakers it sounds sh!t due to the high volume however if you move away or muffle the sound slightly it will sound a lot better).
His older TV cards needed this higher strength signal to operate, if it didn't I would have just gotten rid of his distribution amplifier.

I hope this helps.
(I have set up a total of 5 of these cards in linux so far and this has been the only issue with the current set of drivers. [Location is Melbourne]).

Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
