Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2CCHqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Mar 2012 02:46:32 -0500
Message-ID: <4F51CCC1.8020308@redhat.com>
Date: Sat, 03 Mar 2012 08:48:17 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Xavion <xavion.0@gmail.com>
CC: "Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux anymore
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com> <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
In-Reply-To: <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/03/2012 01:23 AM, Xavion wrote:
> My Microdia (SN9C201) webcam was working in Linux, but it has been
> failing lately.  Take a look at the attached snapshot to see what I
> mean.  It's like that all the time in Linux these days, but it works
> perfectly in Windows.

Thanks for the picture that truely says more then a 1000 words
(Dutch proverb), the problem is that the new bandwidth allocation
code added to gspca in 3.2 does not allocate enough bandwidth for
the sn9c20x. 3.3 has a fix for this.

Regards,

Hans
