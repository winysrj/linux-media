Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7NLmlIw010424
	for <video4linux-list@redhat.com>; Sat, 23 Aug 2008 17:48:47 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7NLmZFh021783
	for <video4linux-list@redhat.com>; Sat, 23 Aug 2008 17:48:35 -0400
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0808181017q1c2467c2g74973deb1c70db97@mail.gmail.com>
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<1217986174.5252.7.camel@morgan.walls.org>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
	<1218939204.3591.25.camel@morgan.walls.org>
	<de8cad4d0808180335l7a6f9377m97c3eff844e187ee@mail.gmail.com>
	<de8cad4d0808181017q1c2467c2g74973deb1c70db97@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 Aug 2008 17:44:20 -0400
Message-Id: <1219527860.11451.2.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Waffle Head <narflex@gmail.com>, video4linux-list@redhat.com,
	ivtv-devel@ivtvdriver.org
Subject: Re: CX18 Oops
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

On Mon, 2008-08-18 at 13:17 -0400, Brandon Jenkins wrote:
> On Mon, Aug 18, 2008 at 6:35 AM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
> > On Sat, Aug 16, 2008 at 10:13 PM, Andy Walls <awalls@radix.net> wrote:
> >> On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
> >>> On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:

> Andy,
> 
> I also seeing these messages in dmesg:
> 
> [65288.817420] cx18-0: Cannot find buffer 58 for stream TS
> [65288.817440] cx18-0: Could not find buf 58 for stream TS
> [65840.130797] cx18-0: Cannot find buffer 17 for stream TS
> [65840.130797] cx18-0: Could not find buf 17 for stream TS
> [65861.882721] cx18-0: Cannot find buffer 48 for stream TS
> [65861.882741] cx18-0: Could not find buf 48 for stream TS
> [66151.627392] cx18-0: Cannot find buffer 107 for stream encoder MPEG
> [66151.627392] cx18-0: Could not find buf 107 for stream encoder MPEG
> [67632.953680] cx18-0: Cannot find buffer 99 for stream encoder MPEG
> [67632.953680] cx18-0: Could not find buf 99 for stream encoder MPEG
> [67795.527911] cx18-0: Cannot find buffer 106 for stream encoder MPEG
> [67795.527911] cx18-0: Could not find buf 106 for stream encoder MPEG
> 
> Brandon

Brandon,

There is now a fix for this bug as well in my v4l-dvb repo.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
