Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG2CwA3032632
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 21:12:58 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBG2Cj4Z003747
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 21:12:45 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2684751wfc.6
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 18:12:45 -0800 (PST)
Message-ID: <aec7e5c30812151812g34f78720ycee96bea5874820d@mail.gmail.com>
Date: Tue, 16 Dec 2008 11:12:45 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: morimoto.kuninori@renesas.com
In-Reply-To: <umyewhnwk.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u3agtx39i.wl%morimoto.kuninori@renesas.com>
	<aec7e5c30812150328t70117d7fp8eee31de4ac223ae@mail.gmail.com>
	<uskopgdav.wl%morimoto.kuninori@renesas.com>
	<aec7e5c30812151749y601970a6meecbd4393977ccf0@mail.gmail.com>
	<umyewhnwk.wl%morimoto.kuninori@renesas.com>
Cc: V4L-Linux <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH re-send v2] Add interlace support to
	sh_mobile_ceu_camera.c
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

Hi Morimoto-san,

On Tue, Dec 16, 2008 at 11:08 AM,  <morimoto.kuninori@renesas.com> wrote:
>> Let me try to explain in more detail. Today your patch is using the
>> bottom variable in three places:
> (snip)
>> 3. for uv plane
>>   case YUV_MODE:
>>     phys_addr_top += icd->width * icd->height; /* no parenthesis needed */
>>     ceu_write(phys_addr_top);
>>     if (interlace) {
>>       phys_addr_bottom = phys_addr_top + icd->width; /* look, "="
>> instead of "+= */
>>       ceu_write(phys_addr_bottom);
>>     }
>
> wow !!
> I can understand.

Great! Does it work as expected too? I hope so. =)

> Thank you.
> and sorry for my stupid question.

No worries. Thank you for your help!

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
