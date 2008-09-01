Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81CaZ8x015844
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 08:36:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m81CaAbk024644
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 08:36:11 -0400
Date: Mon, 1 Sep 2008 14:35:44 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jean Delvare <jdelvare@suse.de>
Message-ID: <20080901123544.GA447@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<200808301201.47561.jdelvare@suse.de>
	<20080830151233.GA221@daniel.bse>
	<200809011144.54233.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809011144.54233.jdelvare@suse.de>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: bttv driver questions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Sep 01, 2008 at 11:44:53AM +0200, Jean Delvare wrote:
> > It's not that much faster. Of the 250MB/s a lot is lost to overhead,
> > especially when there are mostly short packets.
> 
> The very same is true of the PCI side, isn't it? Out of the 133 MB/s
> of PCI bandwith I don't expect to get more than 100 MB/s effective.

You are right. PCI is only faster for transfers of 4 bytes or less.
The throughput formula for memory writes without waitstates on PCI is
  400/3*x/(x+8) MB
and for memory writes with infinite credit without ECRC on PCIe
  250*x/(x+20) MB,
where x is the burst size and must be a multiple of four in both
protocols.

> Actually there may be up to 8 masters. Latency counter values of 254
> and 20 are rather extreme values.

The equilibrium pattern for latency values between 20 and 254 at a
trigger of 4 in my simulation is the same.

> I guess that your computations assume that the BT878 returns the bus
> control as soon as its FIFO is empty?

Yes

> Not sure what you call "maximum fill"? If the FIFO triggers at 32, I
> have a hard time believing that it always gets the control within the
> next 0.17 µs (2 pixels).

There is an initial phase of about 2000 PCI cycles where the FIFO fill
may be higher (this is not the case for a trigger of 4). Afterwards they
acquire the bus in a uniform pattern and stay below the quoted values.
At a trigger of 32 the bus is idle between requests, so access is granted
immediately.

> Again, I fail to see how we care about the idle cycles. I agree that
> we don't have to pay attention to having  a lot of them, because the
> BT878s are alone on that side of the bridge, but we also don't need
> to maximize the "raw" bus usage. What matters is that the bus can
> take the bandwidth peaks and that the FIFOs do never overflow.

It's not about maximizing the bus usage. I suggest to use a low trigger
to keep the FIFO usage low. The high bus usage is just a side effect,
which can be neglected if the Bt878s are on a secondary bus (and either
the primary bus is faster or the bridge can merge writes).

> Care to share your simulation tool with me? This seems to be a very
> valuable tool for the problem I am trying to solve.

Attached.
Cycle description, FIFO overflows and periodic bus idleness estimations
on stderr. FIFO fill for all masters in every cycle on stdout.

  Daniel

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pcisim.c"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static int busstate;
static int nextbusstate;
static int gnt;
static unsigned long long clk;

#define N 5

static struct master {
  int req;
  int fifofill;
  int trigger;
  int latval;
  int latcnt;
  int phase;
  unsigned long long step; /* fixed point 32 bit mantissa */
  unsigned long long accu;
} masters[N];

static void simulate(int i)
{
  masters[i].fifofill+=masters[i].accu>>32;
  masters[i].accu&=0xffffffff;
  if(masters[i].fifofill>140) {
    fprintf(stderr,"%llu [%i dropped %i]\n",clk,i,masters[i].fifofill-140);
    masters[i].fifofill=140;
  }
  if(busstate==0 && gnt==i && masters[i].fifofill>=masters[i].trigger) {
    nextbusstate=1;
    masters[i].phase=1;
  }
  if(busstate==1) {
    switch(masters[i].phase) {
      case 1:
	masters[i].phase=2;
	masters[i].latval=masters[i].latcnt;
	fprintf(stderr,"%llu %i addr\n",clk,i);
	break;
      case 2:
	masters[i].fifofill--;
	fprintf(stderr,"%llu %i data, %i remaining\n",clk,i,masters[i].fifofill);
    }
    if(masters[i].latval>0)
      masters[i].latval--;
    if(masters[i].phase && (masters[i].fifofill==1 || (!masters[i].latval && gnt!=i)))
      nextbusstate=2;
  }
  if(busstate==2 && masters[i].phase) {
    masters[i].fifofill--;
    fprintf(stderr,"%llu %i final data, %i remaining\n",clk,i,masters[i].fifofill);
    if(gnt==i && masters[i].fifofill>=masters[i].trigger) {
      nextbusstate=1;
      masters[i].phase=1;
    } else {
      nextbusstate=0;
      masters[i].phase=0;
    }
  }
  masters[i].req=(masters[i].fifofill>=masters[i].trigger || (masters[i].phase && nextbusstate==1 && masters[i].fifofill>1));
  masters[i].accu+=masters[i].step;
}

int main()
{
  int i;
  unsigned long long idle;
  int wasactive;
  
  clk=idle=0;
  
  busstate=0;
  gnt=0;
  wasactive=0;
  srandom(time(0));
  for(i=0;i<N;i++) {
    masters[i].req=0;
    masters[i].trigger=4;
    masters[i].fifofill=random()%masters[i].trigger;
    masters[i].latcnt=64;
    masters[i].phase=0;
#define PAL(w) (((unsigned long long)(w)<<31)*3/5200)
#define NTSC(w) (((unsigned long long)(w)<<31)*30/52856)
    masters[i].step=NTSC(640);
    masters[i].accu=random()%masters[i].step;
  }
  while(1) {
    int nextgnt=gnt;
    if(wasactive) {
      for(nextgnt=(gnt+1)%N;nextgnt!=gnt;nextgnt=(nextgnt+1)%N)
        if(masters[nextgnt].req)
          break;
      if(nextgnt!=gnt)
	wasactive=0;
    }
    for(i=0;i<N;i++) {
      printf("%i%c",masters[i].fifofill,i+1==N?'\n':'\t');
      simulate(i);
    }
    gnt=nextgnt;
    if(!busstate && nextbusstate)
      wasactive=1;
    clk++;
    if(!nextbusstate) {
      if(busstate)
	fprintf(stderr,"%llu turnaround\n",clk);
      else {
	fprintf(stderr,"%llu idle\n",clk);
	idle++;
      }
    }
    if(!(clk&511))
      fprintf(stderr,"[%llu bus idle %f%%]\n",clk,100.0*idle/clk);
    busstate=nextbusstate;
  }
  return 0;
}

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--XsQoSWH+UP9D9v3l--
