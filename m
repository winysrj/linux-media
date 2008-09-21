Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1KhIPA-0003kv-54
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 08:26:49 +0200
Received: by yx-out-2324.google.com with SMTP id 8so157849yxg.41
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 23:26:43 -0700 (PDT)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 01:26:55 -0500
References: <48D32F0E.1000903@curtronics.com>
	<200809202159.50464.vanessaezekowitz@gmail.com>
	<48D5C4FC.4030106@curtronics.com>
In-Reply-To: <48D5C4FC.4030106@curtronics.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809210126.56055.vanessaezekowitz@gmail.com>
Cc: Curt Blank <Curt.Blank@curtronics.com>
Subject: Re: [linux-dvb] Kworld PlusTV HD PCI 120 (ATSC 120)
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

On Saturday 20 September 2008 10:52:28 pm Curt Blank wrote:

> Um, sorry, there are a bunch of other modules loaded too. I was just
> referring to the Conexant related modules.

Ah ok.  Looking at the output of lsmod, it looks like everything loaded ok, and 
the messages from dmesg look right too. 

/me is even more confused.

> Below is the info requested, but it doesn't look like hte dmesg output
> is of much help.

After stripping out the usb-storage messages, what's left may be of use to the 
others here on the list.

> Oh and I noticed here: http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards
> that the 120 card isn't listed, it would be easier to find I think if it
> was. 

It's below the main table, in the "Likely work as is.." section, 
under "Experimental".  I'll create an entry in the main table once we get 
everything working right.

> oh and you asked the v4l team but it looks like this message cam 
> only to me?? (I cc'd my reply.)

oooooops - my fault.  Next time, maybe I should check the "to" address before I 
commit the message.  :-)

Anyways, I forwarded our discussion to the v4l-dvb list so we can get more eyes 
on this issue.  If you're not on that list, you might wish to join it:

http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
