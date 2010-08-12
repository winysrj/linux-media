Return-path: <mchehab@pedra>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56883 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753158Ab0HLThO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 15:37:14 -0400
Date: Thu, 12 Aug 2010 15:36:59 -0400 (EDT)
From: Jarod Wilson <jwilson@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?utf-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <598856820.2275731281641819461.JavaMail.root@zmail04.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20100812074707.GJ645@bicker>
Subject: Re: [patch] IR: ir-raw-event: null pointer dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

----- Dan Carpenter <error27@gmail.com> wrote:
> The original code dereferenced ir->raw after freeing it and setting it
> to NULL.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>


Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com
