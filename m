Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBC8iKxY006020
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 03:44:20 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBC8i6IQ003055
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 03:44:06 -0500
Received: by qyk14 with SMTP id 14so1509890qyk.3
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 00:44:06 -0800 (PST)
Message-ID: <49422453.8080000@gmail.com>
Date: Fri, 12 Dec 2008 03:44:03 -0500
From: Robert William Fuller <hydrologiccycle@gmail.com>
MIME-Version: 1.0
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
References: <A24693684029E5489D1D202277BE894415E6E1A4@dlee02.ent.ti.com>
	<208cbae30812112203o6be4974epb87b3810e2de3581@mail.gmail.com>
In-Reply-To: <208cbae30812112203o6be4974epb87b3810e2de3581@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [REVIEW PATCH 13/14] OMAP: CAM: Add Lens Driver
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

Alexey Klimov wrote:

<snip>

 > I didn't ever see two "=" in one line in code. Is it okay ?

If you do not understand the C programming language, why are you in a 
position to review code?

The "=" operator associates from right to left.  Hence, in the case of 
"a = b = c", c is first assigned to b, then b is assigned to a.

You should understand the concepts of operator precedence and operator 
associativity before you are in a position to review C code.  This is 
elementary.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
