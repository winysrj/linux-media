Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6nJbh005022
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:49:19 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6n8NW000388
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:49:08 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3045625wfc.6
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 23:49:07 -0700 (PDT)
Message-ID: <aec7e5c30810152349w48812129j28bd43fc660b38b6@mail.gmail.com>
Date: Thu, 16 Oct 2008 15:49:07 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0810160814190.3892@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0810160041250.8535@axis700.grange>
	<aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
	<Pine.LNX.4.64.0810160814190.3892@axis700.grange>
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
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

Hi Guennadi,

On Thu, Oct 16, 2008 at 3:24 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 16 Oct 2008, Magnus Damm wrote:
>> Using soc_camera_link sounds like a good idea. I don't agree with you
>> regarding the module parameters - doing that removes the
>> per-camera-instance configuration that the platform data gives us.
>
> Then a new control or raw register access would be a better way, I think.

What about wrapping the color bar mode in #ifdef DEBUG for now? At
least that's simple and requires no infrastructure.

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
