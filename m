Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm9-vm1.bullet.mail.ne1.yahoo.com ([98.138.90.47]:26481 "HELO
	nm9-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965014Ab1GOKC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 06:02:58 -0400
Message-ID: <1310723863.54093.YahooMailClassic@web121817.mail.ne1.yahoo.com>
Date: Fri, 15 Jul 2011 02:57:43 -0700 (PDT)
From: Luiz Ramos <lramos.prof@yahoo.com.br>
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110715094827.1a2211f5@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



--- Em sex, 15/7/11, Jean-Francois Moine <moinejf@free.fr> escreveu:

> De: Jean-Francois Moine <moinejf@free.fr>
> Assunto: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
> Para: linux-media@vger.kernel.org
> Data: Sexta-feira, 15 de Julho de 2011, 4:48
> On Thu, 14 Jul 2011 19:08:39 -0700
> (PDT)
> Luiz Ramos <luizzramos@yahoo.com.br>
> wrote:
> 
> > Signed-off-by: Luiz Carlos Ramos <lramos.prof
> <at> yahoo.com.br>
> > 
> > 
> > --- a/drivers/media/video/gspca/sonixj.c   
>     2011-07-14
> > 13:14:41.000000000 -0300 +++
> > b/drivers/media/video/gspca/sonixj.c   
>     2011-07-14
> > 13:22:26.000000000 -0300 @@ -2386,7 +2386,7 @@ static
> int
> > sd_start(struct gspca_dev *gs reg_w1(gspca_dev, 0x01,
> 0x22);
> > msleep(100); reg01 = SCL_SEL_OD | S_PDN_INV;
> > -           
>    reg17 &= MCK_SIZE_MASK;
> > +           
>    reg17 &= ~MCK_SIZE_MASK; /* that is,
> reset bits 4..0 */
> >           
> reg17 |= 0x04;          /* clock /
> 4 */
> >             
>    break;
> >         }
> 
> Acked-by: Jean-François Moine <moinejf@free.fr>
> 
> Luiz, may you get and try the last gspca tarball from my
> web site? (you
> will have to redo your patch, because I have not yet
> uploaded it)
> 

Ok, I'm now grabbing this tarball: http://moinejf.free.fr/gspca-2.13.2.tar.gz.

The site also features a (some) git repository(ies) but I understood you mean the test version, is it right?

> -- 
> Ken ar c'hentañ    |   
>       ** Breizh ha Linux atav! **
> Jef       
> |        http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks again,

Luiz


