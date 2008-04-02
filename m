Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 2 Apr 2008 14:46:20 +0200
From: Thomas Schuering <linux-dvb@ts4.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080402124620.GA25986@ts4.de>
References: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
	<1dea8a6d0804010841h34f027e7lb4b5342fe45afbb7@mail.gmail.com>
	<37219a840804011319h6fa0d69elbf95b308236e2179@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37219a840804011319h6fa0d69elbf95b308236e2179@mail.gmail.com>
Cc: alan@redhat.com, video4linux-list@redhat.com,
	Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>,
	LInux DVB <linux-dvb@linuxtv.org>, Ben Caldwell <benny.caldwell@gmail.com>
Subject: Re: [linux-dvb] Dvico Dual 4 card not working.
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

Hi Mike,

On Tue, Apr 01, 2008 at 04:19:45PM -0400, Michael Krufky wrote:
> 
> Can you try using the v4l-dvb master branch hg repository on
> linuxtv.org again, after applying the attached patch (see below)

Let's see:
mv v4l-dvb v4l-dvb.old
hg clone http://linuxtv.org/hg/v4l-dvb/
cd v4l-dvb
patch -p1 < xc-instance.patch
make
make install
sync
shutdown -r


> Please let me know if this fixes the problem, and I'll produce a new
> patch afterwards.

I don't know what problem you're refering to - the machine comes up
successfully, but you can't use the card.

I used 'scan' for testing what gives an entry in /var/log/kern.log:
xc2028 0-0061: Loading 3 firmware images from xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7

Then the process 'kdvb-fe-0' eats up 100% CPU-time,
the keyboard is dead. The machine hangs.

Hope this helps.


Regards, Thomas

os: Ubuntu 7.10
Linux tronn 2.6.22-14-generic #1 SMP Tue Feb 12 02:46:46 UTC 2008 x86_64 GNU/Linux
DViCO DualDig4 rev. 1.0

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
