Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7PJF9QI006878
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 15:15:10 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.181])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7PJEff6023386
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 15:14:42 -0400
Received: by ik-out-1112.google.com with SMTP id c30so1969077ika.3
	for <video4linux-list@redhat.com>; Mon, 25 Aug 2008 12:14:41 -0700 (PDT)
Message-ID: <de8cad4d0808251214q7285377ayfc02499ca33e1a3e@mail.gmail.com>
Date: Mon, 25 Aug 2008 15:14:40 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1219527860.11451.2.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
	<de8cad4d0808060357r4849d935k2e61caf03953d366@mail.gmail.com>
	<1218070521.2689.15.camel@morgan.walls.org>
	<de8cad4d0808070636q4045b788s6773a4e168cca2cc@mail.gmail.com>
	<1218205108.3003.44.camel@morgan.walls.org>
	<de8cad4d0808111433y4620b726wc664a06d7422e883@mail.gmail.com>
	<1218939204.3591.25.camel@morgan.walls.org>
	<de8cad4d0808180335l7a6f9377m97c3eff844e187ee@mail.gmail.com>
	<de8cad4d0808181017q1c2467c2g74973deb1c70db97@mail.gmail.com>
	<1219527860.11451.2.camel@morgan.walls.org>
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

On Sat, Aug 23, 2008 at 5:44 PM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2008-08-18 at 13:17 -0400, Brandon Jenkins wrote:
>> On Mon, Aug 18, 2008 at 6:35 AM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
>> > On Sat, Aug 16, 2008 at 10:13 PM, Andy Walls <awalls@radix.net> wrote:
>> >> On Mon, 2008-08-11 at 17:33 -0400, Brandon Jenkins wrote:
>> >>> On Fri, Aug 8, 2008 at 10:18 AM, Andy Walls <awalls@radix.net> wrote:
>
>> Andy,
>>
>> I also seeing these messages in dmesg:
>>
>> [65288.817420] cx18-0: Cannot find buffer 58 for stream TS
>> [65288.817440] cx18-0: Could not find buf 58 for stream TS
>> [65840.130797] cx18-0: Cannot find buffer 17 for stream TS
>> [65840.130797] cx18-0: Could not find buf 17 for stream TS
>> [65861.882721] cx18-0: Cannot find buffer 48 for stream TS
>> [65861.882741] cx18-0: Could not find buf 48 for stream TS
>> [66151.627392] cx18-0: Cannot find buffer 107 for stream encoder MPEG
>> [66151.627392] cx18-0: Could not find buf 107 for stream encoder MPEG
>> [67632.953680] cx18-0: Cannot find buffer 99 for stream encoder MPEG
>> [67632.953680] cx18-0: Could not find buf 99 for stream encoder MPEG
>> [67795.527911] cx18-0: Cannot find buffer 106 for stream encoder MPEG
>> [67795.527911] cx18-0: Could not find buf 106 for stream encoder MPEG
>>
>> Brandon
>
> Brandon,
>
> There is now a fix for this bug as well in my v4l-dvb repo.
>
> Regards,
> Andy
>
>

Andy,

Thank you very much. I am sorry I have not been overly responsive to
your previous questions.

The audio chirping is on analog coax tuner which is tuned to channel 3
for FiOS set top box use. I will do another pull and then make the
change as you suggested earlier. It only seems to affect the shows my
wife likes to watch.. (Or I am too busy only watching HD)

Thanks again

Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
