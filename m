Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35232 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbdI2Pof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 11:44:35 -0400
Date: Fri, 29 Sep 2017 12:44:25 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
Message-ID: <20170929124425.6a8b5595@recife.lan>
In-Reply-To: <20170929122931.2d9781ea@recife.lan>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <cover.1506546492.git.mchehab@s-opensource.com>
        <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
        <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
        <20170929122931.2d9781ea@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Sep 2017 12:29:31 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Thu, 28 Sep 2017 18:28:32 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
> > Hi Mauro,
> >   
> > > Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:  
> 
> > > +It is possible to document nested structs unions, like::
> > > +
> > > +      /**
> > > +       * struct nested_foobar - a struct with nested unions and structs
> > > +       * @arg1: - first argument of anonymous union/anonymous struct
> > > +       * @arg2: - second argument of anonymous union/anonymous struct
> > > +       * @arg3: - third argument of anonymous union/anonymous struct
> > > +       * @arg4: - fourth argument of anonymous union/anonymous struct
> > > +       * @bar.st1.arg1 - first argument of struct st1 on union bar
> > > +       * @bar.st1.arg2 - second argument of struct st1 on union bar
> > > +       * @bar.st2.arg1 - first argument of struct st2 on union bar
> > > +       * @bar.st2.arg2 - second argument of struct st2 on union bar    
> > 
> > Sorry, this example is totally broken --> below I attached a more
> > elaborate example. 
> > 
> > /* parse-SNIP: my_struct */
> > /**
> > * struct my_struct - a struct with nested unions and structs
> > * @arg1: first argument of anonymous union/anonymous struct
> > * @arg2: second argument of anonymous union/anonymous struct
> > * @arg3: third argument of anonymous union/anonymous struct
> > * @arg4: fourth argument of anonymous union/anonymous struct
> > * @bar.st1.arg1: first argument of struct st1 on union bar
> > * @bar.st1.arg2: second argument of struct st1 on union bar
> > * @bar.st2.arg1: first argument of struct st2 on union bar
> > * @bar.st2.arg2: second argument of struct st2 on union bar
> > * @bar.st3.arg2: second argument of struct st3 on union bar
> > */
> > struct my_struct {
> >    /* Anonymous union/struct*/
> >    union {
> > 	struct {
> > 	    __u8 arg1 : 1;
> > 	    __u8 arg2 : 3;
> > 	};
> >        struct {
> >            int arg1;
> >            int arg2;
> >        };  
> 
> I added a:
> 
> 	#define __u8 char
> 
> In order to compile the above. As reported by gcc 7, this is broken:
> 
> test2.h:22:16: error: duplicate member ‘arg1’
>             int arg1;
>                 ^~~~
> test2.h:23:16: error: duplicate member ‘arg2’
>             int arg2;
>                 ^~~~
> 
> You can't have two symbols with the same name on different anonymous
> structs.

I guess the enclosed nested struct covers all weirdness that we want
to be covered, and it does compile without errors/warnings.

Regards,
Mauro

- 

/* Test code to test nested structs */

/**
 * struct my_struct - a struct with nested unions and structs
 * @arg1: first argument of anonymous union/anonymous struct
 * @arg2: second argument of anonymous union/anonymous struct
 * @arg1b: first argument of anonymous union/anonymous struct
 * @arg2b: second argument of anonymous union/anonymous struct
 * @arg3: third argument of anonymous union/anonymous struct
 * @arg4: fourth argument of anonymous union/anonymous struct
 * @bar.st1.arg1: first argument of struct st1 on union bar
 * @bar.st1.arg2: second argument of struct st1 on union bar
 * @bar.st2.arg1: first argument of struct st2 on union bar
 * @bar.st2.arg2: second argument of struct st2 on union bar
 * @bar.st3.arg2: second argument of struct st3 on union bar
 * @f1: nested function on anonimous union/struct
 * @bar.st2.f2: nested function on named union/struct
 */
struct my_struct {
   /* Anonymous union/struct*/
   union {
	struct {
	    char arg1 : 1;
	    char arg2 : 3;
	};
       struct {
           int arg1b;
           int arg2b;
       };
       struct {
           void *arg3;
           int arg4;
           int (*f1)(char foo, int bar);
       };
   };
   union {
       struct {
           int arg1;
           int arg2;
       } st1;           /* bar.st1 is undocumented, cause a warning */
       struct {
           void *arg1;  /* bar.st3.arg1 is undocumented, cause a warning */
	    int arg2;
          int (*f2)(char foo, int bar); /* bar.st3.fn2 is undocumented, cause a warning */
       } st2, st3;
       int (*f3)(char foo, int bar); /* f3 is undocumented, cause a warning */
   } bar;               /* bar is undocumented, cause a warning */

   /* private: */
   int undoc_privat;    /* is undocumented but private, no warning */

   /* public: */
   int undoc_public;    /* is undocumented, cause a warning */
};
