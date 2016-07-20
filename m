Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:56573 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbcGTNPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:15:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] [media] doc-rst: Fix some Sphinx warnings
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160720100027.440796a4@recife.lan>
Date: Wed, 20 Jul 2016 15:14:27 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <250A8BC9-A965-4162-BF63-6FFFBCD42D89@darmarit.de>
References: <d612024e7d2acd7ec82c75b5fed271fd61673386.1469017917.git.mchehab@s-opensource.com> <20160720100027.440796a4@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.07.2016 um 15:00 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Wed, 20 Jul 2016 09:32:15 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
>> Fix all remaining media warnings with ReST that are fixable
>> without changing at the Sphinx code.
>> 
> 
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index 83877719bef4..3d885d97d149 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -180,8 +180,10 @@ struct media_pad {
>> *			view. The media_entity_pipeline_start() function
>> *			validates all links by calling this operation. Optional.
>> *
>> - * .. note:: Those these callbacks are called with struct media_device.@graph_mutex
>> - * mutex held.
>> + * .. note::
>> + *
>> + *    Those these callbacks are called with struct media_device.@graph_mutex
>> + *    mutex held.
>> */
> 
> The kernel-doc script did something wrong here... something bad
> happened with "@graph_mutex". While it is showing the note box
> properly, the message inside is:
> 
> 	"Note
> 
> 	 Those these callbacks are called with struct media_device.**graph_mutex** mutex held."
> 
> 
> E. g. it converted @ to "**graph_mutex**" and some code seemed to
> change it to: "\*\*graph_mutex\*\*", as this message is not showing
> with a bold font, but, instead, with the double asterisks.
> 
> No idea how to fix it.

Thanks for reporting ..
I guess it is the kernel-doc parser, currently I'am trying to eliminate
some base fails of the kernel-doc parser (e.g. you mailed handling of 
c functions) .. for this I test with your media_tree/doc-next ..
if you commit this to your doc-next I have an example (or where could I get it)
I will take a look about this also .. .. give me some time ;-)

-- Markus --

> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

