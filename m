Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <1225825210.8599.5.camel@vanster-laptop>
References: <1223358739.7694.0.camel@vanster-laptop>
	<48EB7BC5.30307@linuxtv.org>
	<faf98b150810071202y5b1ea456o2647fe6917de948d@mail.gmail.com>
	<48EBB644.7060007@linuxtv.org> <1225825210.8599.5.camel@vanster-laptop>
Date: Tue, 04 Nov 2008 21:24:19 +0200
Message-Id: <1225826659.8599.9.camel@vanster-laptop>
Mime-Version: 1.0
From: Pieter <vansterpc@gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Winfast TV2000 XP Global Remote Control
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

Hi Steve,

I have tried to add case statements for the winfast tv2000 xp global
card under both the other winfast devices but to no avail. In both cases
I could not see the remote control listed under the input devices (also
downloaded the input tools from the website and used 'lsinput'). Could
you direct me to any other place within the source I could possible look
or change to try and solve the problem?

Thanks in advance.
Regards
Pieter van Schaik

On Tue, 2008-10-07 at 15:19 -0400, Steven Toth wrote:
> Pieter Van Schaik wrote:
> > Hi Steve,
> > 
> > first of all, I cannot begin to thank you enough for replying I am
most 
> > grateful! Secondly, I apologize if my question seemed idiotic, I
have 
> > still much to learn regarding the open source community.
> > 
> > I am extremely glad to hear that you are one of the maintainers and
I 
> > hope you can provide me with some guidance regarding the following
matter:
> > 
> > I have a winfast tv2000 xp global card installed on a mythbuntu
system. 
> > I have everything working except for the remote control. I
understand 
> > that the remote control should be listed in the output of "cat 
> > /proc/bus/input/devices" but I do not see it there.  I have looked 
> > through the source code of the cx88-input.c file and I noticed that 
> > within the cx88-ir-init() function there is no case statement for
this 
> > particular card, could this be related to my problem? Any guidance
would 
> > be greatly appreciated.
> 
> Please CC the mailing list when it's related to basic kernel issues. 
> (I've re-added them).
> 
> cx88-input.c contains all of the code to handle IR for the cx88
cards. 
> If you don't see a case statement for your card then nobody has 
> implemented IR. Look for similar winfast cards and see how they 
> implement their IR,
> 
> CX88_BOARD_WINFAST_DTV2000H:
> 
> or
> 
> case CX88_BOARD_WINFAST2000XP_EXPERT:
> case CX88_BOARD_WINFAST_DTV1000:
> 
> Add your baord definition in one of these points and see of you can 
> encourage some IR activity.
> 
> Regards,
> 
> Steve
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
