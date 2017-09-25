Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45088
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933306AbdIYSly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 14:41:54 -0400
Date: Mon, 25 Sep 2017 15:41:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2] scripts: kernel-doc: fix nexted handling
Message-ID: <20170925154144.055e3ee7@vento.lan>
In-Reply-To: <A9911D58-7C66-4543-B3AA-AEBA930CDB79@darmarit.de>
References: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
        <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
        <20170924143833.63e9b3cd@vento.lan>
        <A9911D58-7C66-4543-B3AA-AEBA930CDB79@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Sep 2017 18:58:14 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > As reference, I'm testing it with:
> > 
> > 	$ scripts/kernel-doc -rst ./drivers/clk/ingenic/cgu.h 
> > 
> > PS.: I'm pretty sure it can be improved. Also, only the ReST output
> > is working properly on this current version.  
> 
> But other outputs are also benefit from. Anyway, my question is; do
> we really need to support other output formats any longer? .. since
> we can reach other outputs from the reST base.

IMHO, the only other output format we currently doesn't support
is man pages.

My vote is to remove everything else, but ReST and manpages.


> > +    $def =~ s/([{,;])/$1\n/g;  
> 
> Do we need to split at comma (',') ? If we do so, we also split lines like:
> 
>      void   (*find_idlest)(struct clk *, void __iomem **, u8 *, u8 *);   

Yes, I noticed. I have a patch removing commas on a place where I
can't access right now. It is not as simple as just removing, as it
needs to do something else for enums to look nice.
                        
> > +	my $clause = $3;  
> 
> IMO 'definition' would be a better name.

Agreed. The version I just sent renamed it to definition :-)

> 
> > +
> > +	# Split nested struct/union elements as newer ones
> > +	my $cont = 1;
> > +	while ($cont) {
> > +		$cont = 0;
> > +		while ($members =~ s/(struct|union)\s+{([^{}]*)}(\s*\S+\s*)\;?/$1 $3; $2 /g) {  
> 
> Very tricky, it took me awhile to understand, but I guess there 
> is a mistake with the semicolon at the end: substitution is *leftmost*
> so \;? at the end will never match (replaced) and the replacement $3;
> inserts one additional semicolon. Try:
> 
>   s/(struct|union)\s+{([^{}]*)}(\s*\S+\s*)/$1 $3 $2 /g
> 
> I also replaced \S with [^\s;] since \S will also match:
> 
> "union { const char *name; u32 rate; }  sys_clk;int (*scale)"
> -----------------------------------------------^------------- 
> 
> here is the expression I ended with:
> 
>   s/(struct|union)\s+{([^{}]*)}(\s*[^\s;]\s*)/$1 $3 $2 /g
> 

It is actually worse than that... there are some places that do
things like (drivers/w1/w1_netlink.h):

	struct w1_netlink_msg
	{
		__u8				type;
		__u8				status;
		__u16				len;
		union {
			__u8			id[8];
			struct w1_mst {
				__u32		id;
				__u32		res;
			} mst;
		} id;
		__u8				data[0];
	};


There, there's a name after struct (w1_mst). While that sounds weird
on my eyes, it is a valid syntax.

Also, on the above example, there are three "id" identifiers:

	union id;
	id.mst;
	id.mst.id.

So, the logic has to allow specifying descriptions for all tree.

The patch I just sent should address it.														

> > +			$cont = 1;
> > +		};
> > +	};
> > +	# Ignore other nested elements, like enums
> > +	$members =~ s/({[^\{\}]*})//g;
> > +	$nested = $decl_type;  
> 
> What is the latter good for? I guess the 'nested' trick to suppress
> such 'excess' warnings from nested types is no longer needed .. right?

For things like:

	enum { foo, bar } type;

Granted, a good documentation should also describe "foo" and "bar",
but that could be easily done by moving enums out of the struct, or
by add descriptions for "foo" and "bar" at @type: markup.

> 
> I mean the if-not-in-nested-statement in check_sections():
> 
> 				if ($nested !~ m/\Q$sects[$sx]\E/) {
> 				    print STDERR "${file}:$.: warning: " .
> 					"Excess struct/union/enum/typedef member " .
> 					"'$sects[$sx]' " .
> 					"description in '$decl_name'\n";
> 				    ++$warnings;
> 
> So, should we drop this 'nested' stuff also?
> 
> I also recommend to first apply all substitutions and after parse
> the nested stuff (see my linked patch below).
> 
> OK, I spend a day and here is what I have done with the kernel-doc.py:
> 
> patch:   https://github.com/return42/linuxdoc/commit/518b4ef65707b4a
> impact:  https://github.com/return42/sphkerneldoc/commit/ef5bf69
> 
> ATM documentation of nested data types is rare, the most diffs
> you will find in the *impact* link are coming from the change of
> the prototype, but there are also some good examples e.g.:
> 
>   linux_src_doc/include/uapi/linux/videodev2_h.rst
> 
> And here is how it is rendered in HTML (e.g. struct-v4l2-plane):
> 
> new:  https://h2626237.stratoserver.net/kernel/linux_src_doc/include/uapi/linux/videodev2_h.html#struct-v4l2-plane
> old:  https://h2626237.stratoserver.net/kernel_old/linux_src_doc/include/uapi/linux/videodev2_h.html#struct-v4l2-plane
> 
> After all I would say that it was a bit hard to implement & test,
> but at the end I think, this is really a improvement.
> 
> What do you think, can you implement similar in perl (I like
> to pass the ball back to you since your perl is much better
> than my) .. or should we consider to replace the kernel-doc
> parser with the python one [1] ;)

Replacing it is up to Jon ;)

I'll take a look on your implementation as well, and see how
can I improve what I did.

> 
> -- Markus --
> 
> [1] https://return42.github.io/linuxdoc/linux.html
> 
> 
> 
> 
> 
> > 	# ignore members marked private:
> > 	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gosi;
> > @@ -2200,6 +2201,7 @@ sub dump_struct($$) {
> > 			   'struct',
> > 			   {'struct' => $declaration_name,
> > 			    'module' => $modulename,
> > +			    'definition' => $clause,
> > 			    'parameterlist' => \@parameterlist,
> > 			    'parameterdescs' => \%parameterdescs,
> > 			    'parametertypes' => \%parametertypes,
> > 
> > 
> > 
> > Thanks,
> > Mauro
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



Thanks,
Mauro
