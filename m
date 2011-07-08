Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58521 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab1GHSvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 14:51:10 -0400
References: <CAE_m23n+Hj3xkC5UrUow64mLGaKAOKmR8yPDAATnZ=kWpqWaKw@mail.gmail.com> <4E170176.8090506@redhat.com>
In-Reply-To: <4E170176.8090506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Pach under review.
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 08 Jul 2011 14:51:12 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Marco_Diego_Aur=E9lio_Mesquita?=
	<marcodiegomesquita@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Message-ID: <fe526c05-87cb-419b-a3dd-7f4a150da5a3@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>Em 07-07-2011 23:12, Marco Diego Aurélio Mesquita escreveu:
>> Hi!
>> 
>> I would like to have my patch[1] ready for linux 3.0. It's a simple
>> one-liner to solve an easy to fix problem. Is there anything I can do
>> o accelerate the review process?
>> 
>> Please, CC me your answers as I'm not subscribed to the list.
>> 
>> Tanks!
>> 
>> [1] https://patchwork.kernel.org/patch/849142/
>
>
>Hi Marco,
>
>Hans is currently in vacations, so, we'll likely need to wait for his
>return.
>I prefer to not rush merging it, because I don't have the pac207
>datasheets,
>and it is a good idea to have more tests on it. What webcams had you
>tested
>needing such fix?
>
>Thanks,
>Mauro
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

FWIW, a PAC207 datasheet is on line here:

http://www.soiseek.com/PIXART/PAC207BCA/index.htm

Regards,
Andy
