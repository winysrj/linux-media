Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0JGWpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 18:45:25 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o97MjOgN016528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 18:45:25 -0400
Received: from [10.3.225.63] (vpn-225-63.phx2.redhat.com [10.3.225.63])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o97MjMbd012039
	for <linux-media@vger.kernel.org>; Thu, 7 Oct 2010 18:45:23 -0400
Message-ID: <4CAE4D82.3020702@redhat.com>
Date: Thu, 07 Oct 2010 19:45:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: =?ISO-8859-1?Q?Drivers_for_ISDB-T_=7C_Drivers_para_o?=
 =?ISO-8859-1?Q?_Sistema_Brasileiro_de_Televis=E3o?=
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

PS.: This email will probably be more useful for Brazilians and other people at
Latin America. So, I'll write it in Portuguese. It basically says that 5 families
of ISDB-T devices are now supported on my tree ( http://git.linuxtv.org/mchehab/sbtvd.git), 
including 3 experimental ones. I'm not sure if the new drivers work in Japan. So,
feedbacks are appreciated.

---

Prezados,

Estive trabalhando no meu tempo livre com alguns cartões novos que recebi. Agradeço
a todos aqueles que nos tem ajudado, colocando estes cartões à nossa disposição.

Basicamente, estou adicionando, em caráter experimental, o suporte a 3 dispositivos
que trabalhei recentemente, capazes de receber sinais digitais no padrão SBTVD -
Sistema Brasileiro de Televisão Digital - dentro do Linux. São todos drivers abertos,
ainda experimentais. Agradecemos retorno quanto a problemas em seu funcionamento.

Todos os drivers para esses dispositivos estão em:
	http://git.linuxtv.org/mchehab/sbtvd.git

Na medida em que conseguirmos colocar suporte para novos drivers, eu colocarei os
novos patches na árvore acima. Como de praxe, todos os drivers serão incorporados
na minha árvore principal, à medida em que estiverem 100%, para serem incorporados
nos novos kernels.

Com isso, temos suporte a 5 famílias de dispositivos:

1) Dibcom 0700 + DibCom 807x/809x:
	Full-Seg - ou seja: pega canais HD, SD e LD;
	driver dib0700. Nos meus testes, está funcionando 100%
	Dispositivo testado: Pixelview SBTVD.
	Driver: dib0700

2) Siano 11xx:
	1Seg - pega apenas canais de baixa resolução (LD)
	Também funciona 100%
 	O controle remoto funciona apenas na árvore de desenvolvimento.
	Creio que os patches para o IR estão também na árvore do Linus. Ou seja,
	devem estar funcionando à partir do kernel 2.6.36.
	Dispositivo testado: Hauppauge WinTV MiniStick.
	Driver: smsusb
	
3) Empiatech em28xx + Sharp VA3A5JZ921 (etiquetado como S.921 no chip):
	1Seg - pega apenas canais de baixa resolução (LD)
	Nos meus testes, conseguimos detectar os canais corretamente. No entanto,
	o frontend requer sinais muito fortes. Por conta disso, não consegui
	efetivamente pegar nenhum canal por aqui, embora ache que ele esteja
	funcionando. Assim, aguardo testes para verificar se está 100%. 
	Como não possuo documentação alguma, o driver do frontend basicamente 
	repete a inicialização feita no driver original.
	Dispositivo testado: Leadership ISDB-T.
	Driver: em28xx

4) Conexant cx23102 + Fujitsu MB86A20S
	Full-Seg - ou seja: pega canais HD, SD e LD;
	Também funciona em modo analógico.
	O driver para o frontend também repete a inicialização feita no driver
	original. Nos meus testes, peguei os dois canais disponíveis em minha
	localidade, tanto em 1seg quanto em fullseg.
	Ainda faltam implementar algumas coisas, tais como controle remoto.
	Não testei ainda as entradas S-Video/Composite.
	Dispositivo: Pixelview SBTVD Hybrid.
	Driver: cx231xx

5) NXP TDA7135 + Fujitsu MB86A20S;
	Full-Seg - ou seja: pega canais HD, SD e LD;
	A placa suporta TV analógica. No entanto, a parte analógica ainda não funciona.
	O driver para o frontend é o mesmo do tipo anterior.
	Ainda falta implementar controle remoto, S-Video/Composite e TV analógica.
	Dispositivo: Kworld PCI SBTVD/ISDB-T Hybrid.
	Driver: saa7134

Todos os dispositivos conhecidos são auto-detectados.

Para uso, basta seguir as instruções abaixo:

Instalar git e rodar os comandos:

    	git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
    	cd v4l-dvb
    	git remote add media git://linuxtv.org/mchehab/sbtvd.git
       	git remote update
    	git checkout -b sbtvd media/sbtvd
	make oldconfig
	make
	make modules_install install

O make oldconfig irá perguntar quais drivers novos você deseja compilar. Não esqueça de
solicitar que ele compile os drivers novos do video4linux/DVB. A dificuldade desse passo
depende da distribuição que você tem. Quanto mais próxima ela for da última versão do
kernel, menos perguntas serão feitas ;) Por favor, evitem enviar-me perguntas relacionadas
a compilação do kernel. Eu dificilmente terei tempo para respondê-las, ou poderei ajudar
muito, visto que a seleção de alguns drivers e parametros depende grandemente da distribuição 
que você usa (no meu caso, eu uso o RHEL 6 beta).

O Douglas escreveu um tutorial sobre como usar dispositivos SBTVD:
	http://br-linux.org/2009/sbtvd-assistindo-tv-digital-aberta-brasileira-com-o-vlc-no-linux/

O uso independe do tipo de cartão. Apenas lembre-se que canais HD e SD não serão exibidos
em dispositivos 1-Seg (embora ele detete a existência de canais HD/SD).

Por favor, reportem-me casos de sucesso nesses dispositivos, e/ou eventuais necessidades de
ajuste. 

Qualquer coisa, estamos à disposição.

Abraços,
Mauro

