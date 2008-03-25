Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JeG4D-0006QO-63
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 21:48:22 +0100
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803250459w7072b688ybbc8df32495b4@mail.gmail.com>
References: <8ad9209c0803240521s5426c957te42339397aac06ab@mail.gmail.com>
	<47E7D194.80603@gmx.net>
	<8ad9209c0803250459w7072b688ybbc8df32495b4@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-XdpUhfEUCJP7t6ibb2vh"
Date: Tue, 25 Mar 2008 21:47:12 +0100
Message-Id: <1206478032.19513.3.camel@anden.nu>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Adding timestamp to femon
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-XdpUhfEUCJP7t6ibb2vh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I won't go in and fiddle with femon, but I wrote up a little piece for
y'all. It acts as a filter, so you can use it for timestamping whatever
line-based output you want.

Have fun.

  // J


On Tue, 2008-03-25 at 12:59 +0100, Patrik Hansson wrote:
> On 3/24/08, P. van Gaans <w3ird_n3rd@gmx.net> wrote:
> > On 03/24/2008 01:21 PM, Patrik Hansson wrote:
> > > Hello
> > > I couldn't find a mailinglist for dvb-apps so i hope this is ok.
> > >
> > > I would like to add timestamp to the output of femon -H in some way.
> > > This so I can monitor ber value over a long timeperiod and see the
> > > timedifference between some very high ber-values.
> > >
> > > I found a patch from 2005 but was unable to manually use the code in
> > > dvb-apps/utils/femon/femon.c
> > > I have zero skill in c/c++ but for someone with some skill i would
> > > belive it would be very easy ?
> > >
> > > Ps. If there is a better place for this kind of question please tell me. Ds.
> > >
> > > / Patrik
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> >
> > Hi,
> >
> > I had a similar issue, but solved it. Not sure if this works with a
> > recent femon, but if it doesn't you should be able to make some changes
> > to my method to make it work. Here's the trick:
> >
> > 1. Tune to whatever you want to measure.
> > 2. Execute in a terminal: "femon -h -c 3600 > filename.signal". 3600 is
> > for one hour, if you want to test for e.g. 10 hours enter 36000. The
> > resulting file will usually be under 5MB so don't worry. Good advice:
> > put the current time in the filename because brains are unreliable.
> > 3. That's quite a bit to read. But we can do it faster:
> >
> > Total amount of errors: "cat filename.signal | grep -c unc[^\s][^0]".
> > You might need to change the regex for other femon versions.
> >
> > All errors and when they occured: "cat filename.signal | grep -n
> > unc[^\s][^0]". -n will make it show line numbers. If the first error,
> > for example, is on line 1800 that means the first error occured half an
> > hour after the start of the measurement.
> >
> > Hope this helps.
> >
> > P. van Gaans
> >
> 
> Thank you, it will have to do.
> Using grep -v "ber 0" -n though but that should result in the same.
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

--=-XdpUhfEUCJP7t6ibb2vh
Content-Disposition: attachment; filename=ts.c
Content-Type: text/x-csrc; name=ts.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/*******
 * ts.c
 *
 * Tiny timestamping filter for line-based output, written by
 * Jonas Anden <jonas@anden.nu>. You may use it for whatever you
 * like as long as this header is retained. But don't blame
 * me if it breaks anything ;)
 *
 *  // J
 *
 *******/

#define MAXLINELEN 1024

#include <stdio.h>
#include <time.h>
#include <string.h>

/*
 * Compile with:
 * gcc -Wall -o ts ts.c
 *
 * Sample use:
 * $ (for i in `seq 1 10`; do echo "Line $i"; sleep 1; done) | ./ts '%H:%m:%S [%%s] <- On a %A'
 * 21:03:23 [Line 1] <- On a Tuesday
 * 21:03:24 [Line 2] <- On a Tuesday
 * 21:03:25 [Line 3] <- On a Tuesday
 * 21:03:26 [Line 4] <- On a Tuesday
 * 21:03:27 [Line 5] <- On a Tuesday
 * 21:03:28 [Line 6] <- On a Tuesday
 * 21:03:29 [Line 7] <- On a Tuesday
 * 21:03:30 [Line 8] <- On a Tuesday
 * 21:03:31 [Line 9] <- On a Tuesday
 * 21:03:32 [Line 10] <- On a Tuesday
 *
 */
int main( int argc, char *argv[] )
{
  time_t t;
  struct tm *tmp;
  int buflen;
  char buf[MAXLINELEN],
       tbuf[MAXLINELEN];

  if( argc != 2)
  {
    printf( "Usage:\n cat stream | %s <format> | cat > timestamped-stream\nformat is a date(1) compatible time format with\na %%%%s where you want the input line. Example: %s \"%%H:%%m:%%S [%%%%s] <- On a %%A\"\n\nWARNING: Due to the inherent format string \"vulnerability\",\n         DO NOT make this a setuid binary.\n", argv[0], argv[0] );
    return 1;
  }

  while( !feof( stdin ) )
  {
    if( fgets(buf, MAXLINELEN, stdin) == NULL )
      break;
    buflen=strlen(buf);
    t = time(NULL);
    tmp = localtime(&t);
    if( strftime(tbuf, MAXLINELEN, argv[1], tmp) == 0 )
      break;
    if( buf[buflen-1] == '\n' )
      buf[buflen-1] = 0;
    printf( tbuf, buf );
    putchar('\n');
    fflush(stdout);
  }
  return 0;
}


--=-XdpUhfEUCJP7t6ibb2vh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-XdpUhfEUCJP7t6ibb2vh--
