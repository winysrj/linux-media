Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:57990 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968772AbdIZMpd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 08:45:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] scripts: kernel-doc: fix nexted handling
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170925154144.055e3ee7@vento.lan>
Date: Tue, 26 Sep 2017 14:45:08 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0BDD5AC2-EECB-4748-9DDE-DDD7AC0062D3@darmarit.de>
References: <3d54014d786733715a94fa783a479a498aaca1ea.1506248420.git.mchehab@s-opensource.com>
 <4F0B529A-AF0A-48F9-808A-594BF07D035B@darmarit.de>
 <20170924143833.63e9b3cd@vento.lan>
 <A9911D58-7C66-4543-B3AA-AEBA930CDB79@darmarit.de>
 <20170925154144.055e3ee7@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 25.09.2017 um 20:41 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

>>> +			$cont = 1;
>>> +		};
>>> +	};
>>> +	# Ignore other nested elements, like enums
>>> +	$members =~ s/({[^\{\}]*})//g;
>>> +	$nested = $decl_type;  
>> 
>> What is the latter good for? I guess the 'nested' trick to suppress
>> such 'excess' warnings from nested types is no longer needed .. right?
> 
> For things like:
> 
> 	enum { foo, bar } type;
> 
> Granted, a good documentation should also describe "foo" and "bar",
> but that could be easily done by moving enums out of the struct, or
> by add descriptions for "foo" and "bar" at @type: markup.


Hm .. I suppose you are misunderstanding me. I didn't asked about 
$members, I asked about $nested. There is only one place where
$nested is used, and this is in the check_sections function ...

@@ -2531,9 +2527,7 @@ sub check_sections($$$$$$) {
 			} else {
-				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "${file}:$.: warning: " .
-					"Excess struct/union/enum/typedef member " .
-					"'$sects[$sx]' " .
-					"description in '$decl_name'\n";
-				    ++$warnings;
-				}
+                            print STDERR "${file}:$.: warning: " .
+                                "Excess struct/union/enum/typedef member " .
+                                "'$sects[$sx]' " .
+                                "description in '$decl_name'\n";
+                            ++$warnings;
 			}

Since this is the only place where $nested is use, we can drop all
the occurrence of $nested in the kernel-doc script .. or I'am
totally wrong?

  -- Markus --
