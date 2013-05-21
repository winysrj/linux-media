Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:1679 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3EULyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 07:54:17 -0400
Message-ID: <519B6034.4070709@asianux.com>
Date: Tue, 21 May 2013 19:53:24 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: josephdanielwalter@gmail.com, Greg KH <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: strncpy issue, need always let NUL terminated
 string  ended by zero.
References: <5188EF5C.3030003@asianux.com> <20130521084713.3cbf25c2@redhat.com>
In-Reply-To: <20130521084713.3cbf25c2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/21/2013 07:47 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 07 May 2013 20:11:08 +0800
> Chen Gang <gang.chen@asianux.com> escreveu:
> 
>> > 
>> > For NUL terminated string, need always let it ended by zero.
>> > 
>> > The 'name' may be copied to user mode ('dvb_fe->ops.info' is 'struct
>> > dvb_frontend_info' which is defined in ./include/uapi/...), and its
>> > length is also known within as102_dvb_register_fe(), so need fully
>> > initialize it (not use strlcpy instead of strncpy).
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  drivers/staging/media/as102/as102_fe.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
>> > index 9ce8c9d..b3efec9 100644
>> > --- a/drivers/staging/media/as102/as102_fe.c
>> > +++ b/drivers/staging/media/as102/as102_fe.c
>> > @@ -334,6 +334,7 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
>> >  	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
>> >  	strncpy(dvb_fe->ops.info.name, as102_dev->name,
>> >  		sizeof(dvb_fe->ops.info.name));
>> > +	dvb_fe->ops.info.name[sizeof(dvb_fe->ops.info.name) - 1] = '\0';
> Instead, the better would be to use strlcpy(), as it warrants that the
> copied string will be nul-terminated.

Within this function, we know 'dvb_fe->ops.info' my copy to user mode
(the structure is defined in ./include/uapi/...), and we also known the
full length of the buffer, so better still use strncpy to give a full
initialized, and still be sure of the nul-terminated.


Thanks.
-- 
Chen Gang

Asianux Corporation
