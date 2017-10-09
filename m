Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:46937 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751401AbdJIJwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 05:52:44 -0400
Mime-Version: 1.0
Date: Mon, 09 Oct 2017 09:45:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-ID: <86aa27403023de9051a9fa28375adcab@hardeman.nu>
From: "=?utf-8?B?RGF2aWQgSMOkcmRlbWFu?=" <david@hardeman.nu>
Subject: Re: [PATCH 07/19] lirc_dev: remove kmalloc in lirc_dev_fop_read()
To: "Mauro Carvalho Chehab" <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, sean@mess.org
In-Reply-To: <20171004135558.53df2b1d@recife.lan>
References: <20171004135558.53df2b1d@recife.lan>
 <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
 <149839391031.28811.5094791739782133013.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

October 4, 2017 6:57 PM, "Mauro Carvalho Chehab" <mchehab@s-opensource.co=
m> wrote:=0A=0A> Em Sun, 25 Jun 2017 14:31:50 +0200=0A> David H=C3=A4rdem=
an <david@hardeman.nu> escreveu:=0A> =0A>> lirc_zilog uses a chunk_size o=
f 2 and ir-lirc-codec uses sizeof(int).=0A>> =0A>> Therefore, using stack=
 memory should be perfectly fine.=0A>> =0A>> Signed-off-by: David H=C3=A4=
rdeman <david@hardeman.nu>=0A>> ---=0A>> drivers/media/rc/lirc_dev.c | 8 =
+-------=0A>> 1 file changed, 1 insertion(+), 7 deletions(-)=0A>> =0A>> d=
iff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c=0A>=
> index 1773a2934484..92048d945ba7 100644=0A>> --- a/drivers/media/rc/lir=
c_dev.c=0A>> +++ b/drivers/media/rc/lirc_dev.c=0A>> @@ -376,7 +376,7 @@ s=
size_t lirc_dev_fop_read(struct file *file,=0A>> loff_t *ppos)=0A>> {=0A>=
> struct irctl *ir =3D file->private_data;=0A>> - unsigned char *buf;=0A>=
> + unsigned char buf[ir->buf->chunk_size];=0A> =0A> No. We don't do dyna=
mic buffer allocation on stak at the Kernel,=0A> as this could cause the =
Linux stack to overflow without notice.=0A=0AWhile the general policy is =
to avoid large stack allocations (in order to not overflow the 4K stack),=
 I'm not aware of a general ban on *any* stack allocations - that sounds =
like an overly dogmatic approach. If such a generic ban exists, could you=
 please point me to some kind of discussion/message to that effect?=0A=0A=
The commit message clearly explained what kind of stack allocations we're=
 talking about here (i.e. sizeof(int) is the maximum), so the stack alloc=
ation is clearly not able to cause stack overflows. And once the last lir=
c driver is gone, this can be changed to a simple int (which would also b=
e allocated on stack).=0A=0ARegards,=0ADavid
