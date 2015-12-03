Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57432 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbbLCV13 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 16:27:29 -0500
Date: Thu, 3 Dec 2015 19:27:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Oliver Schinagl <oliver@houseofmozart.com>
Subject: Re: [PATCH 0/3] Update Brazilian channel tables
Message-ID: <20151203192724.41efa62b@recife.lan>
In-Reply-To: <56604A24.3040402@schinagl.nl>
References: <1436188155-18875-1-git-send-email-mchehab@osg.samsung.com>
 <559AD4D4.5010906@schinagl.nl>
 <559AD6CA.4060602@schinagl.nl>
 <20151203115513.6c08f850@recife.lan>
 <56604A24.3040402@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(re-sent as vger didn't recognize the original post)

Em Thu, 03 Dec 2015 14:56:52 +0100
Olliver Schinagl <oliver@schinagl.nl> escreveu:

> Hey Mauro,
> 
> On 03-12-15 14:55, Mauro Carvalho Chehab wrote:
> > Em Mon, 6 Jul 2015 21:28:10 +0200
> > Olliver Schinagl <oliver@schinagl.nl> escreveu:
> >
> >> I tried to manually fix things, by changing the charset to utf-8 in the
> >> saved e-mail. That worked but it was only wrong for patch 1/3 and 3/3. I
> >> blindly did assume it was utf-8 so i'm not sure if I got for patch 1:
> >>
> >> warning: squelched 70 whitespace errors
> >> warning: 75 lines add whitespace errors.
> >>
> >> and about the same for patch 3 the same amount.
> >>
> >> So i have the correct data now in my local tree (sans the whtiespace
> >> fixes). Do you want me to push them as is, or do you want to see/fix
> >> things first?
> > Hi Olliver,
> >
> > It seems that you're not finding much time lately to apply those
> > patches, as there are some patches pending for quite some time at
> > patchwork.
> Are there? I admit I do not check patchwork, I'll have to re-learn to 
> use patchwork. I apply everything I get via e-mail though within a few days.

Applying via email is ok. The big advantage of patchwork is that it
prevents us to forget something.

So, in thesis, all patches sent to the ML should also be at patchwork,
as it stores every valid patch there. The status update of the patch
is manual, though.

Yet, with the patchwork version we've just upgraded, there's a way to
tell patchwork to automatically update a patch when it gets applied
upstream via a hook.

I installed such hook today. Let's see if it will work. If it works, it
should print something like:

	remote: I: 1 patch(es) updated to state Accepted.

after the patch got pushed upstream.

> >
> > If you don't mind, I would like to add myself to it, as this way
> > I can drop those patches from patchwork, avoiding me to look on
> > them every time I review the pending patches ;)
> No problem, feel free to add them! As an excersize however, should I do 
> this round of patchwork files?
> 
> Can you send me a link to a patch so I can figure it out from there on out?

I'm seeing those two patches:

Patchwork: http://patchwork.linuxtv.org/patch/31537/
Patchwork: http://patchwork.linuxtv.org/patch/32006/

plus this broken one:

Patchwork: http://patchwork.linuxtv.org/patch/31724/

Regards,
Mauro


> 
> My appologies for not looking at the right place!
> >
> > Regards,
> > Mauro
> >
> >> Olliver
> >>
> >> On 06-07-15 21:19, Olliver Schinagl wrote:
> >>> Hey Mauro,
> >>>
> >>> I still am having issues with your patches. Maybe my workflow is wrong
> >>> or my git installation is somehow borked, but i'm getting:
> >>>
> >>> git am \[PATCH\ 1_3\]\ Update\ Brazilian\ ISDB-T\ tables\ -\ Mauro\
> >>> Carvalho\ Chehab\ \<mchehab\@osg.samsung.com\>\ -\ 2015-07-06\ 1509.eml
> >>> fatal: cannot convert from true to UTF-8
> >>>
> >>> I download the messages from thunderbird as email's and then run git am
> >>> on them. This tends to work from others just fine. My git is from a
> >>> pretty recent build, git version 2.3.6. I am one of the crazy people
> >>> that does use gentoo for things, but that should be pretty UTF-8 happy..
> >>> ([ebuild   R    ] dev-vcs/git-2.3.6::gentoo USE="blksha1 curl gpg iconv
> >>> mediawiki nls pcre perl python subversion threads webdav -cgi -cvs -doc
> >>> -emacs -gnome-keyring -gtk -highlight (-ppcsha1) {-test} -tk -xinetd"
> >>> PYTHON_TARGETS="python2_7" 0 KiB). Then again, it complains about not
> >>> being able to convert from 'true', whatever that may be? THe mail header
> >>> does list the content type as being true: Content-Type: text/plain;
> >>> charset=true. Patch 0/3 however does not even have any content-type. All
> >>> very strange this is!
> >>>
> >>> Can you send them as patches or send me a pull-request? (or feel free to
> >>> push them yourself ;)
> >>>
> >>> Olliver
> >>>
> >>> On 06-07-15 15:09, Mauro Carvalho Chehab wrote:
> >>>> The Brazilian channel tables were updated in Oct, 2014.
> >>>> There were lots of changes since there, as Digital TV is
> >>>> still under deployment in Brazil.
> >>>>
> >>>> So, update all tables to reflect the current status.
> >>>>
> >>>> Mauro Carvalho Chehab (3):
> >>>>      Update Brazilian ISDB-T tables
> >>>>      Rename ISDB-T table for Gama city
> >>>>      Add new cities to Brazilian ISDB-T lists
> >>>>
> >>>>     isdb-t/br-al-Maceio                               |  58 +++++++
> >>>>     isdb-t/br-al-MatrizDeCamaragibe                   |  61 ++++++++
> >>>>     isdb-t/br-al-PalmeiraDosIndios                    |  32 ++++
> >>>>     isdb-t/br-al-Penedo                               |  32 ++++
> >>>>     isdb-t/br-am-BocaDoAcre                           |  32 ++++
> >>>>     isdb-t/br-am-Itacoatiara                          |  32 ++++
> >>>>     isdb-t/br-am-Manaus                               |  60 +-------
> >>>>     isdb-t/br-am-Parintins                            |  29 ++++
> >>>>     isdb-t/br-ba-Barreiras                            |  29 ++++
> >>>>     isdb-t/br-ba-Camacari                             |  31 +++-
> >>>>     isdb-t/br-ba-ConceicaoDaFeira                     |  29 ----
> >>>>     isdb-t/br-ba-ConceicaoDoJacuipe                   |  87 +++++++++++
> >>>>     isdb-t/br-ba-CruzDasAlmas                         |  89 ++++++++++-
> >>>>     isdb-t/br-ba-Eunapolis                            |  29 ++++
> >>>>     isdb-t/br-ba-FeiraDeSantana                       |  29 ++++
> >>>>     isdb-t/br-ba-Itabuna                              |  29 ++++
> >>>>     isdb-t/br-ba-Juazeiro                             |  29 ++++
> >>>>     isdb-t/br-ba-Pojuca                               |  60 +++++++-
> >>>>     isdb-t/br-ba-Salvador                             |  31 +++-
> >>>>     isdb-t/br-ba-SantoAntonioDeJesus                  |   2 +-
> >>>>     isdb-t/br-ba-Seabra                               |  32 ++++
> >>>>     isdb-t/br-ba-VitoriaDaConquista                   |  29 ----
> >>>>     isdb-t/br-ce-Aquiraz                              |  58 +++++++
> >>>>     isdb-t/br-ce-Camocim                              |  32 ++++
> >>>>     isdb-t/br-ce-Crateus                              |  32 ++++
> >>>>     isdb-t/br-ce-Fortaleza                            |  87 +++++++++++
> >>>>     isdb-t/br-ce-Horizonte                            |  29 ++++
> >>>>     isdb-t/br-ce-Iguatu                               |  32 ++++
> >>>>     isdb-t/br-ce-Itapipoca                            |  32 ++++
> >>>>     isdb-t/br-ce-Massape                              |  32 ++++
> >>>>     isdb-t/br-ce-Pacajus                              |  29 ++++
> >>>>     isdb-t/br-ce-Russas                               |  32 ++++
> >>>>     isdb-t/br-ce-Sobral                               |  29 ++++
> >>>>     isdb-t/br-df-Brasilia                             |  61 ++++++--
> >>>>     isdb-t/br-df-Gama                                 | 177 ++++++++++++++++++++++
> >>>>     isdb-t/br-es-Aracruz                              |   4 +-
> >>>>     isdb-t/br-es-Itapemirim                           |  32 ++++
> >>>>     isdb-t/br-es-JoaoNeiva                            |  32 ++++
> >>>>     isdb-t/br-es-Marataizes                           |  33 +++-
> >>>>     isdb-t/br-es-Piuma                                |  32 ++++
> >>>>     isdb-t/br-es-VendaNovaDoImigrante                 |  32 ++++
> >>>>     isdb-t/br-go-AguasLindasDeGoias                   |  31 +---
> >>>>     isdb-t/br-go-Anapolis                             |  29 ++++
> >>>>     isdb-t/br-go-AparecidaDeGoiania                   |  29 ++++
> >>>>     isdb-t/br-go-CaldasNovas                          |  58 +++++++
> >>>>     isdb-t/br-go-Catalao                              |  29 ++++
> >>>>     isdb-t/br-go-Formosa                              |  35 +----
> >>>>     isdb-t/br-go-Goianesia                            |  29 ++++
> >>>>     isdb-t/br-go-Goiania                              |  29 ++++
> >>>>     isdb-t/br-go-Goiatuba                             |  29 ++++
> >>>>     isdb-t/br-go-Itumbiara                            |  29 ++++
> >>>>     isdb-t/br-go-Jatai                                |  58 +++++++
> >>>>     isdb-t/br-go-Luziania                             |  58 +++++++
> >>>>     isdb-t/br-go-Minacu                               |  32 ++++
> >>>>     isdb-t/br-go-Morrinhos                            |  32 ++++
> >>>>     isdb-t/br-go-Quirinopolis                         |  32 ++++
> >>>>     isdb-t/br-go-RioVerde                             |  58 +++++++
> >>>>     isdb-t/br-go-SantoAntonioDoDescoberto             |  31 +---
> >>>>     isdb-t/br-go-SenadorCanedo                        |  29 ++++
> >>>>     isdb-t/br-go-Uruacu                               |  32 ++++
> >>>>     isdb-t/br-go-ValparaisoDeGoias                    |  31 +++-
> >>>>     isdb-t/br-ma-Rosario                              |  31 +++-
> >>>>     isdb-t/br-ma-SantaRita                            | 119 +++++++++++++++
> >>>>     isdb-t/br-ma-SaoLuis                              |  29 ++++
> >>>>     isdb-t/br-mg-Araguari                             |  29 ++++
> >>>>     isdb-t/br-mg-Arapora                              |  29 ++++
> >>>>     isdb-t/br-mg-Araxa                                |  29 ++++
> >>>>     isdb-t/br-mg-ConselheiroLafaiete                  |   6 +-
> >>>>     isdb-t/br-mg-Coromandel                           |  32 ++++
> >>>>     isdb-t/br-mg-Divinopolis                          |  29 ++++
> >>>>     isdb-t/br-mg-Itabira                              |  29 ++++
> >>>>     isdb-t/br-mg-Ituiutaba                            |  58 +++++++
> >>>>     isdb-t/br-mg-Iturama                              |  32 ++++
> >>>>     isdb-t/br-mg-Lavras                               |  61 ++++++++
> >>>>     isdb-t/br-mg-Leopoldina                           |  29 ++++
> >>>>     isdb-t/br-mg-MontesClaros                         |  29 ++++
> >>>>     isdb-t/br-mg-PatosDeMinas                         |  29 ++++
> >>>>     isdb-t/br-mg-PocosDeCaldas                        |  58 +++++++
> >>>>     isdb-t/br-mg-PonteNova                            |  32 ++++
> >>>>     isdb-t/br-mg-PousoAlegre                          |  29 ++++
> >>>>     isdb-t/br-mg-Sacramento                           |  32 ++++
> >>>>     isdb-t/br-mg-SantaRitaDoSapucai                   |   2 +-
> >>>>     isdb-t/br-mg-SantaVitoria                         |  32 ++++
> >>>>     isdb-t/br-mg-SeteLagoas                           |  31 +++-
> >>>>     isdb-t/br-mg-TeofiloOtoni                         |  33 +++-
> >>>>     isdb-t/br-mg-TresPontas                           |  29 ++++
> >>>>     isdb-t/br-mg-Uberlandia                           |  29 ++++
> >>>>     isdb-t/br-mg-Varginha                             |  29 ++++
> >>>>     isdb-t/br-ms-Amambai                              |  32 ++++
> >>>>     isdb-t/br-ms-CampoGrande                          |  60 +++++++-
> >>>>     isdb-t/br-ms-Dourados                             |  29 ++++
> >>>>     isdb-t/br-ms-Navirai                              |  29 ++++
> >>>>     isdb-t/br-ms-NovaAndradina                        |  29 ++++
> >>>>     isdb-t/br-ms-TresLagoas                           |  29 ++++
> >>>>     isdb-t/br-mt-Cuiaba                               |  31 +++-
> >>>>     isdb-t/br-mt-Juina                                |  58 +++++++
> >>>>     isdb-t/br-mt-Rondonopolis                         |  31 +++-
> >>>>     isdb-t/br-mt-Sinop                                |  58 +++++++
> >>>>     isdb-t/br-pa-Abaetetuba                           |  29 ++++
> >>>>     isdb-t/br-pa-Belem                                |  60 +++++++-
> >>>>     isdb-t/br-pa-Belterra                             |  29 ++++
> >>>>     isdb-t/br-pa-Castanhal                            |   2 +-
> >>>>     isdb-t/br-pa-Santarem                             |  29 ++++
> >>>>     isdb-t/br-pa-Tucurui                              |  32 ++++
> >>>>     isdb-t/br-pb-CampinaGrande                        |  29 ++++
> >>>>     isdb-t/br-pb-JoaoPessoa                           |  29 ----
> >>>>     isdb-t/br-pe-Caruaru                              |  58 +++++++
> >>>>     isdb-t/br-pe-Gravata                              |  90 +++++++++++
> >>>>     isdb-t/br-pe-Limoeiro                             |   4 +-
> >>>>     isdb-t/br-pe-Pesqueira                            |  29 ++++
> >>>>     isdb-t/br-pe-Petrolina                            |  29 ++++
> >>>>     isdb-t/br-pe-Recife                               |  31 +++-
> >>>>     isdb-t/br-pe-VitoriaDeSantoAntao                  |  58 +++++++
> >>>>     isdb-t/br-pi-LuisCorreia                          |  29 ++++
> >>>>     isdb-t/br-pi-Parnaiba                             |  29 ++++
> >>>>     isdb-t/br-pi-Piripiri                             |  32 ++++
> >>>>     isdb-t/br-pr-Apucarana                            |   6 +-
> >>>>     isdb-t/br-pr-Araruna                              |  32 ++++
> >>>>     isdb-t/br-pr-Cambe                                |  29 ++++
> >>>>     isdb-t/br-pr-CampoMourao                          |  29 ++++
> >>>>     isdb-t/br-pr-Carambei                             |  29 ++++
> >>>>     isdb-t/br-pr-Cianorte                             |  87 +++++++++++
> >>>>     isdb-t/br-pr-Curitiba                             |  29 ++++
> >>>>     isdb-t/br-pr-Florestopolis                        |  87 +++++++++++
> >>>>     isdb-t/br-pr-Londrina                             |  29 ++++
> >>>>     isdb-t/br-pr-Maringa                              |  87 +++++++++++
> >>>>     isdb-t/br-pr-Matinhos                             |  29 ++++
> >>>>     isdb-t/br-pr-Medianeira                           |  32 ++++
> >>>>     isdb-t/br-pr-Morretes                             |  90 +++++++++++
> >>>>     isdb-t/br-pr-Palmeira                             |  32 ++++
> >>>>     isdb-t/br-pr-Paranagua                            |  29 ++++
> >>>>     isdb-t/br-pr-PontaGrossa                          |  29 ++++
> >>>>     isdb-t/br-pr-PontalDoParana                       |  58 +++++++
> >>>>     isdb-t/br-pr-SantoAntonioDaPlatina                |  32 ++++
> >>>>     isdb-t/br-pr-SaoMiguelDoIguacu                    |  32 ++++
> >>>>     isdb-t/br-pr-Sarandi                              |  87 +++++++++++
> >>>>     isdb-t/br-pr-Sertanopolis                         |  29 ++++
> >>>>     isdb-t/br-pr-Tibagi                               |  32 ++++
> >>>>     isdb-t/br-rj-AngraDosReis                         |  58 +++++++
> >>>>     isdb-t/br-rj-Araruama                             |  31 +++-
> >>>>     isdb-t/br-rj-BarraDoPirai                         |  58 +++++++
> >>>>     isdb-t/br-rj-BarraMansa                           |  33 +++-
> >>>>     isdb-t/br-rj-CaboFrio                             |  87 +++++++++++
> >>>>     isdb-t/br-rj-Cambuci                              |  32 ++++
> >>>>     isdb-t/br-rj-CamposDosGoytacazes                  |  33 +++-
> >>>>     isdb-t/br-rj-DuqueDeCaxias                        |  60 +++++++-
> >>>>     isdb-t/br-rj-Itaguai                              |  31 +++-
> >>>>     isdb-t/br-rj-Itaperuna                            |  58 +++++++
> >>>>     isdb-t/br-rj-Macae                                |  29 ++++
> >>>>     isdb-t/br-rj-Marica                               |   2 +-
> >>>>     isdb-t/br-rj-NovaFriburgo                         |  58 +++++++
> >>>>     isdb-t/br-rj-Petropolis                           |  29 ++++
> >>>>     isdb-t/br-rj-Pirai                                |  32 ++++
> >>>>     isdb-t/br-rj-Queimados                            |   2 +-
> >>>>     isdb-t/br-rj-Quissama                             |  58 +++++++
> >>>>     isdb-t/br-rj-Resende                              |  58 +++++++
> >>>>     isdb-t/br-rj-RioDasOstras                         |  29 ++++
> >>>>     isdb-t/br-rj-RioDeJaneiro                         |   2 +-
> >>>>     isdb-t/br-rj-SaoJoaoDaBarra                       |  29 ++++
> >>>>     isdb-t/br-rj-Teresopolis                          |  29 ++++
> >>>>     isdb-t/br-rj-TresRios                             |  58 +++++++
> >>>>     isdb-t/br-rj-Valenca                              |  87 +++++++++++
> >>>>     isdb-t/br-rj-Vassouras                            |  58 +++++++
> >>>>     isdb-t/br-rj-VoltaRedonda                         |  33 +++-
> >>>>     isdb-t/br-rn-Mossoro                              |  29 ++++
> >>>>     isdb-t/br-rn-Natal                                |  35 ++++-
> >>>>     isdb-t/br-ro-Ariquemes                            |  29 ++++
> >>>>     isdb-t/br-ro-Jiparana                             |   2 +-
> >>>>     isdb-t/br-ro-PimentaBueno                         |   2 +-
> >>>>     isdb-t/br-ro-PortoVelho                           |  31 +++-
> >>>>     isdb-t/br-rr-BoaVista                             |  29 ++++
> >>>>     isdb-t/br-rs-Ajuricaba                            |  32 ++++
> >>>>     isdb-t/br-rs-ArroioDoSal                          |  33 +---
> >>>>     isdb-t/br-rs-Bage                                 |  29 ++++
> >>>>     isdb-t/br-rs-CapaoDaCanoa                         |  29 ++++
> >>>>     isdb-t/br-rs-CaxiasDoSul                          |  29 ++++
> >>>>     isdb-t/br-rs-CruzAlta                             |  29 ++++
> >>>>     isdb-t/br-rs-Farroupilha                          |  29 ++++
> >>>>     isdb-t/br-rs-FredericoWestphalen                  |  32 ++++
> >>>>     isdb-t/br-rs-Garibaldi                            |  32 ++++
> >>>>     isdb-t/br-rs-GetulioVargas                        |  32 ++++
> >>>>     isdb-t/br-rs-HulhaNegra                           |  32 ++++
> >>>>     isdb-t/br-rs-Ijui                                 |  29 ++++
> >>>>     isdb-t/br-rs-Itaqui                               |  61 ++++++++
> >>>>     isdb-t/br-rs-Osorio                               |  58 -------
> >>>>     isdb-t/br-rs-PassoFundo                           |  29 ++++
> >>>>     isdb-t/br-rs-PortoAlegre                          |  29 ++++
> >>>>     isdb-t/br-rs-SantoAntonioDaPatrulha               |  29 ++++
> >>>>     isdb-t/br-rs-TerraDeAreia                         |  29 ++++
> >>>>     isdb-t/br-rs-Torres                               |  58 +++++++
> >>>>     isdb-t/br-rs-TresCachoeiras                       |   4 +-
> >>>>     isdb-t/br-rs-Vacaria                              |   4 +-
> >>>>     isdb-t/br-rs-VenancioAires                        |  29 ++++
> >>>>     isdb-t/br-sc-AntonioCarlos                        |  29 ----
> >>>>     isdb-t/br-sc-BalnearioCamboriu                    |  29 ++++
> >>>>     isdb-t/br-sc-BarraVelha                           |  58 +++++++
> >>>>     isdb-t/br-sc-Blumenau                             |  29 ++++
> >>>>     isdb-t/br-sc-Brusque                              |   6 +-
> >>>>     isdb-t/br-sc-ChapadaoDoLageado                    |  32 ++++
> >>>>     isdb-t/br-sc-Criciuma                             |  58 +++++++
> >>>>     isdb-t/br-sc-Gaspar                               |  29 ++++
> >>>>     isdb-t/br-sc-Guabiruba                            |  29 ----
> >>>>     isdb-t/br-sc-HervalDOeste                         |  58 +++++++
> >>>>     isdb-t/br-sc-Itajai                               |  58 +++++++
> >>>>     isdb-t/br-sc-JaraguaDoSul                         |  29 ++++
> >>>>     isdb-t/br-sc-Joacaba                              |  29 ++++
> >>>>     isdb-t/br-sc-Joinville                            |  29 ++++
> >>>>     isdb-t/br-sc-Laguna                               |  29 ++++
> >>>>     isdb-t/br-sc-Mafra                                |   4 +-
> >>>>     isdb-t/br-sc-Navegantes                           |  58 +++++++
> >>>>     isdb-t/br-sc-Palmeira                             |  32 ++++
> >>>>     isdb-t/br-sc-Penha                                |  62 +++++++-
> >>>>     isdb-t/br-sc-Sombrio                              |  29 ++++
> >>>>     isdb-t/br-sc-Tubarao                              |  29 ----
> >>>>     isdb-t/br-se-CedroDeSaoJoao                       |  32 ++++
> >>>>     isdb-t/br-se-Propria                              |  29 ++++
> >>>>     isdb-t/br-sp-Adamantina                           |  32 ++++
> >>>>     isdb-t/br-sp-AguasDaPrata                         |  32 ++++
> >>>>     isdb-t/br-sp-AguasDeSantaBarbara                  |  32 ++++
> >>>>     isdb-t/br-sp-Agudos                               |  29 ++++
> >>>>     isdb-t/br-sp-Altinopolis                          |  32 ++++
> >>>>     isdb-t/br-sp-Americana                            |  33 +++-
> >>>>     isdb-t/br-sp-Amparo                               |  31 +++-
> >>>>     isdb-t/br-sp-Angatuba                             |  32 ++++
> >>>>     isdb-t/br-sp-Aparecida                            |  43 +++++-
> >>>>     isdb-t/br-sp-Aracatuba                            |  87 +++++++++++
> >>>>     isdb-t/br-sp-Araraquara                           |  87 +++++++++++
> >>>>     isdb-t/br-sp-Araras                               |  29 ++++
> >>>>     isdb-t/br-sp-Assis                                |  31 +++-
> >>>>     isdb-t/br-sp-Atibaia                              |   2 +-
> >>>>     isdb-t/br-sp-Avare                                |  32 ++++
> >>>>     isdb-t/br-sp-Barretos                             |  58 +++++++
> >>>>     isdb-t/br-sp-Barrinha                             |  32 ++++
> >>>>     isdb-t/br-sp-Batatais                             |  29 ++++
> >>>>     isdb-t/br-sp-Bauru                                |  31 +++-
> >>>>     isdb-t/br-sp-Bebedouro                            |  29 ++++
> >>>>     isdb-t/br-sp-Bertioga                             |  89 +----------
> >>>>     isdb-t/br-sp-Birigui                              |  87 +++++++++++
> >>>>     isdb-t/br-sp-Botucatu                             |  58 +++++++
> >>>>     isdb-t/br-sp-BragancaPaulista                     |   4 +-
> >>>>     isdb-t/br-sp-Brodowski                            |  31 +++-
> >>>>     isdb-t/br-sp-CachoeiraPaulista                    |  31 +++-
> >>>>     isdb-t/br-sp-Cajamar                              |  31 +++-
> >>>>     isdb-t/br-sp-Campinas                             |  33 +++-
> >>>>     isdb-t/br-sp-CamposDoJordao                       |   4 +-
> >>>>     isdb-t/br-sp-Cananeia                             |  61 ++++++++
> >>>>     isdb-t/br-sp-Capivari                             |  29 ++++
> >>>>     isdb-t/br-sp-Caraguatatuba                        |  60 +++++++-
> >>>>     isdb-t/br-sp-Carapicuiba                          |  77 +++++++---
> >>>>     isdb-t/br-sp-Cerquilho                            |  58 +++++++
> >>>>     isdb-t/{br-df-BrasiliaGama => br-sp-CesarioLange} |  22 +--
> >>>>     isdb-t/br-sp-Cravinhos                            |  31 +++-
> >>>>     isdb-t/br-sp-Cruzeiro                             |  60 +++++++-
> >>>>     isdb-t/br-sp-Cubatao                              |  58 -------
> >>>>     isdb-t/br-sp-Descalvado                           |  58 +++++++
> >>>>     isdb-t/br-sp-Diadema                              |  64 ++++----
> >>>>     isdb-t/br-sp-Dracena                              |  29 ++++
> >>>>     isdb-t/br-sp-Eldorado                             |  29 ++++
> >>>>     isdb-t/br-sp-EmbuDasArtes                         |  44 +++---
> >>>>     isdb-t/br-sp-EspiritoSantoDoPinhal                |  32 ++++
> >>>>     isdb-t/br-sp-Fernandopolis                        |  29 ++++
> >>>>     isdb-t/br-sp-Garca                                |  64 +++++++-
> >>>>     isdb-t/br-sp-Guaratingueta                        |  62 +++++++-
> >>>>     isdb-t/br-sp-Guariba                              |  29 ++++
> >>>>     isdb-t/br-sp-Guaruja                              |   2 +-
> >>>>     isdb-t/br-sp-Guarulhos                            |  66 ++++----
> >>>>     isdb-t/br-sp-Hortolandia                          |  33 +++-
> >>>>     isdb-t/br-sp-Ibiuna                               |  29 ++++
> >>>>     isdb-t/br-sp-IlhaSolteira                         |  29 ++++
> >>>>     isdb-t/br-sp-Indaiatuba                           |  33 +++-
> >>>>     isdb-t/br-sp-Iporanga                             |  32 ++++
> >>>>     isdb-t/br-sp-Itapetininga                         |   2 +-
> >>>>     isdb-t/br-sp-Itapira                              |  61 ++++++++
> >>>>     isdb-t/br-sp-Itapolis                             |  29 ++++
> >>>>     isdb-t/br-sp-Itaquaquecetuba                      |  78 ++++++++--
> >>>>     isdb-t/br-sp-Itarare                              |  61 ++++++++
> >>>>     isdb-t/br-sp-Itariri                              |  61 ++++++++
> >>>>     isdb-t/br-sp-Itu                                  |  29 ++++
> >>>>     isdb-t/br-sp-Jacarei                              |  64 +++++++-
> >>>>     isdb-t/br-sp-Jau                                  |  60 +++++++-
> >>>>     isdb-t/br-sp-JoseBonifacio                        |  29 ----
> >>>>     isdb-t/br-sp-Leme                                 |  29 ++++
> >>>>     isdb-t/br-sp-LencoisPaulista                      |  29 ++++
> >>>>     isdb-t/br-sp-Limeira                              |  58 +++++++
> >>>>     isdb-t/br-sp-Lins                                 |  29 ++++
> >>>>     isdb-t/br-sp-Lorena                               | 101 +++++++++++-
> >>>>     isdb-t/br-sp-Marilia                              |  60 +++++++-
> >>>>     isdb-t/br-sp-Matao                                |  29 ++++
> >>>>     isdb-t/br-sp-Miracatu                             |  32 ++++
> >>>>     isdb-t/br-sp-Mococa                               |  29 ++++
> >>>>     isdb-t/br-sp-MogiDasCruzes                        | 159 ++++++++++++++++++-
> >>>>     isdb-t/br-sp-Mogiguacu                            |  29 ++++
> >>>>     isdb-t/br-sp-Olimpia                              |  32 ++++
> >>>>     isdb-t/br-sp-OsvaldoCruz                          |  32 ++++
> >>>>     isdb-t/br-sp-Ourinhos                             |  29 ----
> >>>>     isdb-t/br-sp-ParaguacuPaulista                    |  58 +++++++
> >>>>     isdb-t/br-sp-Paulinia                             |  33 +++-
> >>>>     isdb-t/br-sp-Pedreira                             |  32 ++++
> >>>>     isdb-t/br-sp-PedroDeToledo                        |  32 ++++
> >>>>     isdb-t/br-sp-Peruibe                              |  29 ++++
> >>>>     isdb-t/br-sp-Pindamonhangaba                      |  60 +++++++-
> >>>>     isdb-t/br-sp-Piquete                              |   2 +-
> >>>>     isdb-t/br-sp-Piracicaba                           |   4 +-
> >>>>     isdb-t/br-sp-Pirassununga                         |  29 ++++
> >>>>     isdb-t/br-sp-Poa                                  |  60 ++++----
> >>>>     isdb-t/br-sp-PraiaGrande                          |   2 +-
> >>>>     isdb-t/br-sp-PresidenteEpitacio                   |  32 ++++
> >>>>     isdb-t/br-sp-PresidentePrudente                   |  58 +++++++
> >>>>     isdb-t/br-sp-PresidenteVenceslau                  |  29 ++++
> >>>>     isdb-t/br-sp-RibeiraoPreto                        |   6 +-
> >>>>     isdb-t/br-sp-Roseira                              |  24 +--
> >>>>     isdb-t/br-sp-Salto                                |  29 ++++
> >>>>     isdb-t/br-sp-SantoAndre                           |  41 ++++-
> >>>>     isdb-t/br-sp-Santos                               |   2 +-
> >>>>     isdb-t/br-sp-SaoCarlos                            |  29 ++++
> >>>>     isdb-t/br-sp-SaoJoaoDaBoaVista                    |  29 ++++
> >>>>     isdb-t/br-sp-SaoJoseDosCampos                     |  64 +++++++-
> >>>>     isdb-t/br-sp-SaoManuel                            |  29 ++++
> >>>>     isdb-t/br-sp-SaoPaulo                             |  49 ++++--
> >>>>     isdb-t/br-sp-SaoPedro                             |  58 +++++++
> >>>>     isdb-t/br-sp-SaoSebastiao                         |  31 +++-
> >>>>     isdb-t/br-sp-SaoSebastiaoBoicucanga               |  32 ++++
> >>>>     isdb-t/br-sp-SerraNegra                           |  32 ++++
> >>>>     isdb-t/br-sp-Socorro                              |  32 ++++
> >>>>     isdb-t/br-sp-Sorocaba                             |  58 +++++++
> >>>>     isdb-t/br-sp-Sumare                               |  33 +++-
> >>>>     isdb-t/br-sp-Suzano                               |  55 +++++--
> >>>>     isdb-t/br-sp-Taquaritinga                         |  29 ++++
> >>>>     isdb-t/br-sp-Tatui                                |  29 ++++
> >>>>     isdb-t/br-sp-Taubate                              |  31 +++-
> >>>>     isdb-t/br-sp-TeodoroSampaio                       |  32 ++++
> >>>>     isdb-t/br-sp-Tiete                                |  61 ++++++++
> >>>>     isdb-t/br-sp-Tupa                                 |  29 ++++
> >>>>     isdb-t/br-sp-TupiPaulista                         |  29 ++++
> >>>>     isdb-t/br-sp-Ubatuba                              |  31 +++-
> >>>>     isdb-t/br-sp-Valinhos                             |  33 +++-
> >>>>     isdb-t/br-sp-VargemGrandeDoSul                    |  61 ++++++++
> >>>>     isdb-t/br-sp-Votorantim                           |  29 ++++
> >>>>     isdb-t/br-sp-Votuporanga                          |  29 ++++
> >>>>     isdb-t/br-to-MiracemaDoTocantins                  |  29 ----
> >>>>     isdb-t/br-to-Palmas                               |   2 +-
> >>>>     isdb-t/br-to-PortoNacional                        |  29 ----
> >>>>     342 files changed, 11985 insertions(+), 1030 deletions(-)
> >>>>     create mode 100644 isdb-t/br-al-MatrizDeCamaragibe
> >>>>     create mode 100644 isdb-t/br-al-PalmeiraDosIndios
> >>>>     create mode 100644 isdb-t/br-al-Penedo
> >>>>     create mode 100644 isdb-t/br-am-BocaDoAcre
> >>>>     create mode 100644 isdb-t/br-am-Itacoatiara
> >>>>     create mode 100644 isdb-t/br-ba-Seabra
> >>>>     create mode 100644 isdb-t/br-ce-Camocim
> >>>>     create mode 100644 isdb-t/br-ce-Crateus
> >>>>     create mode 100644 isdb-t/br-ce-Iguatu
> >>>>     create mode 100644 isdb-t/br-ce-Itapipoca
> >>>>     create mode 100644 isdb-t/br-ce-Massape
> >>>>     create mode 100644 isdb-t/br-ce-Russas
> >>>>     create mode 100644 isdb-t/br-df-Gama
> >>>>     create mode 100644 isdb-t/br-es-Itapemirim
> >>>>     create mode 100644 isdb-t/br-es-JoaoNeiva
> >>>>     create mode 100644 isdb-t/br-es-Piuma
> >>>>     create mode 100644 isdb-t/br-es-VendaNovaDoImigrante
> >>>>     create mode 100644 isdb-t/br-go-Minacu
> >>>>     create mode 100644 isdb-t/br-go-Morrinhos
> >>>>     create mode 100644 isdb-t/br-go-Quirinopolis
> >>>>     create mode 100644 isdb-t/br-go-Uruacu
> >>>>     create mode 100644 isdb-t/br-ma-SantaRita
> >>>>     create mode 100644 isdb-t/br-mg-Coromandel
> >>>>     create mode 100644 isdb-t/br-mg-Iturama
> >>>>     create mode 100644 isdb-t/br-mg-Lavras
> >>>>     create mode 100644 isdb-t/br-mg-PonteNova
> >>>>     create mode 100644 isdb-t/br-mg-Sacramento
> >>>>     create mode 100644 isdb-t/br-mg-SantaVitoria
> >>>>     create mode 100644 isdb-t/br-ms-Amambai
> >>>>     create mode 100644 isdb-t/br-pa-Tucurui
> >>>>     create mode 100644 isdb-t/br-pe-Gravata
> >>>>     create mode 100644 isdb-t/br-pi-Piripiri
> >>>>     create mode 100644 isdb-t/br-pr-Araruna
> >>>>     create mode 100644 isdb-t/br-pr-Medianeira
> >>>>     create mode 100644 isdb-t/br-pr-Morretes
> >>>>     create mode 100644 isdb-t/br-pr-Palmeira
> >>>>     create mode 100644 isdb-t/br-pr-SantoAntonioDaPlatina
> >>>>     create mode 100644 isdb-t/br-pr-SaoMiguelDoIguacu
> >>>>     create mode 100644 isdb-t/br-pr-Tibagi
> >>>>     create mode 100644 isdb-t/br-rj-Cambuci
> >>>>     create mode 100644 isdb-t/br-rj-Pirai
> >>>>     create mode 100644 isdb-t/br-rs-Ajuricaba
> >>>>     create mode 100644 isdb-t/br-rs-FredericoWestphalen
> >>>>     create mode 100644 isdb-t/br-rs-Garibaldi
> >>>>     create mode 100644 isdb-t/br-rs-GetulioVargas
> >>>>     create mode 100644 isdb-t/br-rs-HulhaNegra
> >>>>     create mode 100644 isdb-t/br-rs-Itaqui
> >>>>     create mode 100644 isdb-t/br-sc-ChapadaoDoLageado
> >>>>     create mode 100644 isdb-t/br-sc-Palmeira
> >>>>     create mode 100644 isdb-t/br-se-CedroDeSaoJoao
> >>>>     create mode 100644 isdb-t/br-sp-Adamantina
> >>>>     create mode 100644 isdb-t/br-sp-AguasDaPrata
> >>>>     create mode 100644 isdb-t/br-sp-AguasDeSantaBarbara
> >>>>     create mode 100644 isdb-t/br-sp-Altinopolis
> >>>>     create mode 100644 isdb-t/br-sp-Angatuba
> >>>>     create mode 100644 isdb-t/br-sp-Avare
> >>>>     create mode 100644 isdb-t/br-sp-Barrinha
> >>>>     create mode 100644 isdb-t/br-sp-Cananeia
> >>>>     rename isdb-t/{br-df-BrasiliaGama => br-df-Gama}
> >>>>     create mode 100644 isdb-t/br-sp-EspiritoSantoDoPinhal
> >>>>     create mode 100644 isdb-t/br-sp-Iporanga
> >>>>     create mode 100644 isdb-t/br-sp-Itapira
> >>>>     create mode 100644 isdb-t/br-sp-Itarare
> >>>>     create mode 100644 isdb-t/br-sp-Itariri
> >>>>     create mode 100644 isdb-t/br-sp-Miracatu
> >>>>     create mode 100644 isdb-t/br-sp-Olimpia
> >>>>     create mode 100644 isdb-t/br-sp-OsvaldoCruz
> >>>>     create mode 100644 isdb-t/br-sp-Pedreira
> >>>>     create mode 100644 isdb-t/br-sp-PedroDeToledo
> >>>>     create mode 100644 isdb-t/br-sp-PresidenteEpitacio
> >>>>     create mode 100644 isdb-t/br-sp-SaoSebastiaoBoicucanga
> >>>>     create mode 100644 isdb-t/br-sp-SerraNegra
> >>>>     create mode 100644 isdb-t/br-sp-Socorro
> >>>>     create mode 100644 isdb-t/br-sp-TeodoroSampaio
> >>>>     create mode 100644 isdb-t/br-sp-Tiete
> >>>>     create mode 100644 isdb-t/br-sp-VargemGrandeDoSul
> >>>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
